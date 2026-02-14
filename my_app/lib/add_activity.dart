import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class AddActivityPage extends StatefulWidget {
  final String userEmail;
  const AddActivityPage({super.key, required this.userEmail});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final descC = TextEditingController();
  final locationC = TextEditingController();
  XFile? _pickedFile;
  Uint8List? _webImageBytes;
  bool saving = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPhoto() async {
    XFile? picked;

    if (kIsWeb) {
      picked = await _picker.pickImage(source: ImageSource.camera);
    } else if (Platform.isWindows) {
      picked = await _picker.pickImage(source: ImageSource.gallery);
    } else {
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

  Future<Position> _getPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw 'Location services disabled';
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      throw 'Location permission denied';
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String?> _uploadPhoto() async {
    if (_pickedFile == null && _webImageBytes == null) return null;

    final fileName = "act_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final storage = Supabase.instance.client.storage.from('activity_photos');

    if (kIsWeb) {
      await storage.uploadBinary(fileName, _webImageBytes!);
    } else {
      final file = File(_pickedFile!.path);
      await storage.upload(fileName, file);
    }

    return storage.getPublicUrl(fileName);
  }

  Future<void> _save() async {
    if (saving) return;
    final desc = descC.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }
    setState(() => saving = true);

    try {
      final pos = await _getPosition();
      final photoUrl = await _uploadPhoto();

      await Supabase.instance.client.from('real_time_data').insert({
        'description': desc,
        'latitude': pos.latitude,
        'longitude': pos.longitude,
        'user_email': widget.userEmail,
        'photo_url': photoUrl,
        'location_text': locationC.text.trim().isEmpty ? null : locationC.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity saved ✅')),
      );
      descC.clear();
      locationC.clear();
      setState(() {
        _pickedFile = null;
        _webImageBytes = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imgWidget = kIsWeb
        ? (_webImageBytes != null ? Image.memory(_webImageBytes!, height: 160) : null)
        : (_pickedFile != null ? Image.file(File(_pickedFile!.path), height: 160) : null);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Activity')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: descC, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 8),
          TextField(controller: locationC, decoration: const InputDecoration(labelText: 'Location (optional note)')),
          const SizedBox(height: 8),
          if (imgWidget != null) imgWidget,
          const SizedBox(height: 8),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _pickPhoto,
                icon: const Icon(Icons.camera_alt),
                label: Text(
                  kIsWeb
                      ? "Pick Image"
                      : Platform.isWindows
                          ? "Select from Gallery"
                          : "Capture Photo",
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _save,
                child: saving ? const CircularProgressIndicator() : const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
