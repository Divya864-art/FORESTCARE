import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportIncidentPage extends StatefulWidget {
  final String userEmail;
  const ReportIncidentPage({super.key, required this.userEmail});

  @override
  State<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  String? selectedIncident;
  XFile? pickedImage;

  final picker = ImagePicker();

  // 📌 Pick image
  Future<void> _pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = image;
      });
    }
  }

  // 📌 Submit report
  Future<void> _submitReport() async {
    if (selectedIncident == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please select an incident type")),
      );
      return;
    }

    String? photoUrl;

    // ✅ Upload photo to Supabase Storage
    if (pickedImage != null) {
      try {
        final fileName =
            "incident_${DateTime.now().millisecondsSinceEpoch}.jpg";
        final fileBytes = await pickedImage!.readAsBytes();

        // ✅ Added fileOptions with contentType
        await Supabase.instance.client.storage
            .from('incident_photos')
            .uploadBinary(
              fileName,
              fileBytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        // Get public URL
        photoUrl = Supabase.instance.client.storage
            .from('incident_photos')
            .getPublicUrl(fileName);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to upload photo: $e")),
        );
        return;
      }
    }

    // ✅ Insert into "incidents" table
    try {
      await Supabase.instance.client.from('incidents').insert({
        'user_email': widget.userEmail,
        'incident_type': selectedIncident,
        'photo_url': photoUrl,
        'description': null,
        'latitude': null,
        'longitude': null,
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Incident reported successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error saving report: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final incidentTypes = [
      {"label": "Illegal Logging", "icon": Icons.warning},
      {"label": "Forest Fire", "icon": Icons.local_fire_department},
      {"label": "Tree Damage", "icon": Icons.eco},
      {"label": "New Growth", "icon": Icons.forest},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Report Incident")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Help us monitor forest health, ${widget.userEmail}",
                style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            // ✅ Select incident type
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: incidentTypes.map((type) {
                return ChoiceChip(
                  label: Text(type['label'] as String),
                  avatar: Icon(type['icon'] as IconData, color: Colors.red),
                  selected: selectedIncident == type['label'],
                  onSelected: (selected) {
                    setState(() {
                      selectedIncident =
                          selected ? type['label'] as String : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ✅ Pick photo
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: Text(
                pickedImage == null ? "Add Photo" : "Photo Selected ✅",
              ),
            ),

            const Spacer(),

            // ✅ Submit
            ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.green,
              ),
              child: const Text("Submit Report"),
            ),
          ],
        ),
      ),
    );
  }
}
