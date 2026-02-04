import 'package:flutter/material.dart';
import 'dart:async';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _controller = PageController();
  final List<PromoModel> _data = [
    PromoModel(
      imageAsset: 'assets/images/safety.jpg',
      title: 'Keselamatan',
      desc: 'Utamakan keselamatan dalam bekerja.',
    ),
    PromoModel(
      imageAsset: 'assets/images/policy.jpg',
      title: 'Pembaruan Kebijakan',
      desc: 'Kebijakan baru efektif 1 September.',
    ),
    PromoModel(
      imageAsset: 'assets/images/work.jpg',
      title: 'Produktivitas',
      desc: 'Bekerja dengan fokus penuh.',
    ),
    PromoModel(
      imageAsset: 'assets/images/fokus.jpg',
      title: 'Fokus',
      desc: 'Jaga fokus untuk hasil maksimal.',
    ),
  ];

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    // Use a slightly longer periodic interval than the animation
    // duration to avoid overlapping animations.
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_controller.hasClients) {
        final nextPage = (_currentPage + 1) % _data.length;
        _controller.animateToPage(
          nextPage,
          // Animation duration set to 3 seconds as requested
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return PromoCard(
                imageAsset: _data[index].imageAsset,
                title: _data[index].title,
                desc: _data[index].desc,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        DotIndicator(currentIndex: _currentPage, count: _data.length),
      ],
    );
  }
}

class PromoCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String desc;

  const PromoCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5EAF1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: _buildImage(),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    const double imageHeight = 100;

    if (imageAsset == 'assets/images/safety.jpg') {
      return SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.82,
            child: Image.asset(
              imageAsset,
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Image.asset(imageAsset, fit: BoxFit.cover),
    );
  }
}

class PromoModel {
  final String imageAsset;
  final String title;
  final String desc;

  PromoModel({
    required this.imageAsset,
    required this.title,
    required this.desc,
  });
}

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index
                ? Colors.blue
                : Colors.grey.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}
