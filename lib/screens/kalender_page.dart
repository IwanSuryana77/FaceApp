import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Colors
const biruModern = Color(0xFF2563EB);
const whiteBg = Color(0xFFF7F8FC);

class EventData {
  final DateTime date;
  final String acara;
  final String id;
  EventData(this.date, this.acara, {this.id = ""});
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<EventData>> _events = {};

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('calendar_events');

  @override
  void initState() {
    super.initState();
    _loadEventsFromFirestore();
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  Future<void> _loadEventsFromFirestore() async {
    final snapshot = await eventCollection.get();
    final Map<DateTime, List<EventData>> eventMap = {};
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['date'] != null && data['acara'] != null) {
        DateTime d = (data['date'] as Timestamp).toDate();
        DateTime groupKey = _normalizeDate(d);
        eventMap.putIfAbsent(groupKey, () => []);
        eventMap[groupKey]!.add(EventData(groupKey, data['acara'], id: doc.id));
      }
    }
    setState(() {
      _events = eventMap;
    });
  }

  Future<void> _addEventToFirestore(DateTime date, String acara) async {
    await eventCollection.add({
      'date': date,
      'acara': acara,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _loadEventsFromFirestore();
  }

  List<EventData> get _eventForSelectedDay {
    final day = _normalizeDate(_selectedDay ?? _focusedDay);
    return _events[day] ?? [];
  }

  Future<void> _pickYearMonth(BuildContext context) async {
    int startYear = 2020;
    int endYear = 2040;
    int currYear = _focusedDay.year;
    int currMonth = _focusedDay.month;

    int pickedYear = currYear;
    int pickedMonth = currMonth;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            "Pilih Bulan & Tahun",
            style: TextStyle(color: biruModern),
          ),
          content: StatefulBuilder(
            builder: (context, setDialogState) => SizedBox(
              width: 280,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: pickedYear,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: biruModern),
                    dropdownColor: Colors.white,
                    onChanged: (val) {
                      if (val != null) setDialogState(() { pickedYear = val; });
                    },
                    items: [
                      for (int y = startYear; y <= endYear; y++)
                        DropdownMenuItem(value: y, child: Text("$y")),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    children: List.generate(12, (i) {
                      final m = i + 1;
                      final isActive = pickedMonth == m;
                      return GestureDetector(
                        onTap: () => setDialogState(() { pickedMonth = m; }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isActive ? biruModern : Colors.white,
                            border: Border.all(color: biruModern.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 13),
                          child: Text(
                            DateFormat('MMMM', 'id_ID').format(DateTime(2000, m)),
                            style: TextStyle(
                              color: isActive ? Colors.white : biruModern,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: biruModern,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(pickedYear, pickedMonth, 1);
                  _selectedDay = DateTime(pickedYear, pickedMonth, 1);
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Pilih'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventDialog() async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Acara", style: TextStyle(color: biruModern)),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Masukkan nama acara'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: biruModern,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              var value = ctrl.text.trim();
              if (value.isEmpty) return;
              final tanggal = _normalizeDate(_selectedDay ?? _focusedDay);
              await _addEventToFirestore(tanggal, value);
              Navigator.of(context).pop();
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showMonthEventsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MonthEventsPage(events: _events, month: _focusedDay),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(51),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 23),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: "Kembali ke Home",
          ),
          title: GestureDetector(
            onTap: () => _pickYearMonth(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('MMM yyyy').format(_focusedDay),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.keyboard_arrow_down,
                    color: Colors.black, size: 20),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => setState(() {
                final now = DateTime.now();
                _focusedDay = DateTime(now.year, now.month, now.day);
                _selectedDay = _focusedDay;
              }),
              child: const Text(
                "Hari ini",
                style: TextStyle(
                  color: biruModern,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ==== Calendar ====
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16, offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TableCalendar<EventData>(
                  locale: 'id_ID',
                  firstDay: DateTime.utc(2005, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  calendarFormat: CalendarFormat.month,
                  eventLoader: (date) => _events[_normalizeDate(date)] ?? [],
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 12.6,
                    ),
                    weekendStyle: const TextStyle(
                      color: Color(0xFFEF3A3A), fontWeight: FontWeight.w600, fontSize: 12.6,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color(0xFFD0EAFF),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: biruModern,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Color(0xFFEF3A3A),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = _normalizeDate(selected);
                      _focusedDay = _normalizeDate(focused);
                    });
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: biruModern, padding: EdgeInsets.zero),
                    onPressed: _showMonthEventsPage,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("Lihat Acara Bulan Ini", style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(width: 3),
                        Icon(Icons.arrow_forward, size: 19),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ==== Card catatan (event/none) ====
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 9, offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "catatan",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A3253),
                      fontSize: 15.4,
                    ),
                  ),
                  const Divider(height: 18, color: Color(0xFFE6ECF3), thickness: 1.2),
                  Expanded(
                    child: _eventForSelectedDay.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.event_busy,
                                    size: 46, color: Colors.redAccent),
                                const SizedBox(height: 10),
                                const Text(
                                  "Tidak ada acara",
                                  style: TextStyle(
                                    color: Color(0xFF222946),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Acara pada tanggal yang dipilih akan terlihat di sini.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _eventForSelectedDay.length,
                            itemBuilder: (ctx, i) {
                              final event = _eventForSelectedDay[i];
                              return Card(
                                elevation: 0,
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  side: BorderSide(
                                    color: biruModern.withOpacity(0.11),
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.event, color: biruModern, size: 26),
                                  title: Text(
                                    event.acara,
                                    style: const TextStyle(
                                      color: Color(0xFF212B47),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('dd MMM yyyy').format(event.date),
                                    style: TextStyle(
                                      color: biruModern.withOpacity(0.7),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: biruModern,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      onPressed: _showAddEventDialog,
                      child: const Text("Tambah"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==== Halaman Daftar Acara Bulan Ini ====
class MonthEventsPage extends StatelessWidget {
  final Map<DateTime, List<EventData>> events;
  final DateTime month;
  const MonthEventsPage({super.key, required this.events, required this.month});

  @override
  Widget build(BuildContext context) {
    const biruModern = Color(0xFF2563EB);
    final eventsInMonth = <EventData>[];
    events.forEach((dt, list) {
      if (dt.year == month.year && dt.month == month.month) {
        eventsInMonth.addAll(list);
      }
    });

    return Scaffold(
      backgroundColor: whiteBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: biruModern),
        title: Text(
          "Acara Bulan ${DateFormat('MMM yyyy').format(month)}",
          style: const TextStyle(
            color: biruModern,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: eventsInMonth.isEmpty
            ? const Center(
                child: Text(
                  "Belum ada acara bulan ini.",
                  style: TextStyle(
                    color: biruModern,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              )
            : ListView.separated(
                itemCount: eventsInMonth.length,
                separatorBuilder: (_, __) => Divider(
                  height: 22,
                  color: biruModern.withOpacity(0.16),
                ),
                itemBuilder: (ctx, i) {
                  final ev = eventsInMonth[i];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: biruModern.withOpacity(0.18),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.event_note, color: biruModern),
                      title: Text(
                        ev.acara,
                        style: const TextStyle(
                          color: biruModern,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMM yyyy').format(ev.date),
                        style: TextStyle(
                          color: biruModern.withOpacity(0.62),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}