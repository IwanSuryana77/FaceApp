import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class UploadService {
  static const String cloudName = 'CLOUD_NAME_KAMU';
  static const String uploadPreset = 'facesign_unsigned';

  static Future<String?> uploadToCloudinary(Uint8List imageBytes) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/dv8zwl76d/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'bitmap.bmp',
        ),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resData =
          json.decode(await response.stream.bytesToString());
      return resData['secure_url'];
    } else {
      return null;
    }
  }
}
