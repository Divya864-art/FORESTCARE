import 'dart:io' show File, Platform; // ✅ Only for mobile/desktop
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CaptureIncidentPage extends StatefulWidget {
  final String officerId; // ✅ changed from int → String

  const CaptureIncidentPage({
    super.key,
    required this.officerId,
  });

  @override
  State<CaptureIncidentPage> createState() => _CaptureIncidentPageState();
}

class _CaptureIncidentPageState extends State<CaptureIncidentPage> {
  Uint8List? _webImageBytes; // ✅ For web
  XFile? _pickedFile;        // ✅ For mobile & web
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    XFile? picked;

    if (kIsWeb) {
      // ✅ Web uses file picker
      picked = await _picker.pickImage(source: ImageSource.camera);
    } else if (Platform.isWindows) {
      // ✅ Windows does not support ImageSource.camera
      picked = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      // ✅ Android / iOS → Camera works
      picked = await _picker.pickImage(source: ImageSource.camera);
    }

    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _pickedFile = picked;
        });
      } else {
        setState(() {
          _pickedFile = picked;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_pickedFile == null && _webImageBytes == null) return;

    try {
      final fileName =
          "${widget.officerId}_${DateTime.now().millisecondsSinceEpoch}.jpg"; // ✅ include officerId in name

      if (kIsWeb) {
        await Supabase.instance.client.storage
            .from("incident_photos")
            .uploadBinary(fileName, _webImageBytes!);
      } else {
        final file = File(_pickedFile!.path);
        await Supabase.instance.client.storage
            .from("incident_photos")
            .upload(fileName, file);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload successful ✅")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Capture Incident (${widget.officerId})")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_webImageBytes != null)
              Image.memory(_webImageBytes!, height: 200)
            else if (_pickedFile != null && !kIsWeb)
              Image.file(File(_pickedFile!.path), height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(
                kIsWeb
                    ? "Pick Image"
                    : Platform.isWindows
                        ? "Select from Gallery"
                        : "Capture Image",
              ),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text("Upload to Supabase"),
            ),
          ],
        ),
      ),
    );
  }
}
