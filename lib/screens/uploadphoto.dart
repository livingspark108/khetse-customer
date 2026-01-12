import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';


import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/constants/image_constants.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/userModel.dart';
import 'package:user/screens/forgot_password_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/screens/otp_verification_screen.dart';
import 'package:user/screens/signup_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/utils/validators.dart';
import 'package:user/widgets/bottom_button.dart';
import 'package:user/widgets/circular_image_cover.dart';
import 'package:user/widgets/my_ink_well.dart';
import 'package:user/widgets/my_text_field.dart';

class ImageUploadPage extends BaseRoute {
  ImageUploadPage({super.analytics, super.observer, super.routeName = 'LoginScreen'});

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}


class _ImageUploadPageState extends BaseRouteState {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  String? _uploadResult;

  // Replace with your actual upload endpoint
  final String uploadUrl = "https://example.com/upload.php";

  Future<void> _requestPermissions() async {
    // Ask for photos/camera permissions
    await [
      Permission.camera,
      Permission.photos, // iOS: photos, Android: storage handled automatically
      Permission.storage, // Android storage if needed
    ].request();
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestPermissions();

    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (picked == null) return; // user cancelled

      setState(() {
        _imageFile = File(picked.path);
        _uploadProgress = 0;
        _uploadResult = null;
      });
    } catch (e) {
      debugPrint("Image pick error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose an image first.")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
      _uploadResult = null;
    });

    try {
      final dio = Dio();

      String fileName = _imageFile!.path.split('/').last;

   /*   final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(_imageFile!.path, filename: fileName),
        // add other form fields here if required, e.g. "uid": "1001"
      });*/

      final response = await dio.post(
        uploadUrl,

        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
        onSendProgress: (int sent, int total) {
          if (total != 0) {
            setState(() {
              _uploadProgress = sent / total;
            });
          }
        },
      );

      setState(() {
        _isUploading = false;
        _uploadResult = "Status: ${response.statusCode}\nResponse: ${response.data}";
      });
    } catch (e) {
      debugPrint("Upload error: $e");
      setState(() {
        _isUploading = false;
        _uploadResult = "Upload failed: $e";
      });
    }
  }

  Widget _buildPreview() {
    if (_imageFile == null) {
      return const Center(child: Text("No image selected"));
    }
    return Image.file(_imageFile!, fit: BoxFit.contain);
  }

  Widget _buildProgress() {
    if (!_isUploading) return const SizedBox.shrink();
    return Column(
      children: [
        LinearProgressIndicator(value: _uploadProgress),
        const SizedBox(height: 8),
        Text("${(_uploadProgress * 100).toStringAsFixed(0)}% uploaded"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Upload UI"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Notes"),
                content: const Text(
                    "Replace uploadUrl with your server endpoint. Make sure server accepts multipart/form-data."),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: _buildPreview(),
              ),
            ),
            const SizedBox(height: 12),
            _buildProgress(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery"),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_forever),
                    label: const Text("Remove"),
                    onPressed: _isUploading
                        ? null
                        : () {
                            setState(() {
                              _imageFile = null;
                              _uploadResult = null;
                              _uploadProgress = 0;
                            });
                          },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload"),
                    onPressed: _isUploading ? null : _uploadImage,
                  ),
                ),
              ],
            ),
            if (_uploadResult != null) ...[
              const SizedBox(height: 12),
              Text(
                _uploadResult!,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


