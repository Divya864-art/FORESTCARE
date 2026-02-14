import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssignTasks extends StatefulWidget {
  const AssignTasks({super.key});

  @override
  State<AssignTasks> createState() => _AssignTasksState();
}

class _AssignTasksState extends State<AssignTasks> {
  List<Map<String, dynamic>> reports = [];
  List<Map<String, dynamic>> officers = [];

  int? selectedReportId;
  String? selectedOfficerEmail;
  final notesC = TextEditingController();

  bool loading = true;
  bool saving = false;

  // ✅ Load reports and officers
  Future<void> _load() async {
    try {
      final rows = await Supabase.instance.client
          .from('real_time_data')
          .select('id,description,created_at')
          .order('created_at', ascending: false);

      final officerRows = await Supabase.instance.client
          .from('officers')
          .select('id, email, name');

      setState(() {
        reports = List<Map<String, dynamic>>.from(rows);
        officers = List<Map<String, dynamic>>.from(officerRows);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  // ✅ Save task assignment
  Future<void> _save() async {
    if (selectedReportId == null || selectedOfficerEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select report and officer')),
      );
      return;
    }

    setState(() => saving = true);
    try {
      await Supabase.instance.client.from('tasks').insert({
        'report_id': selectedReportId,
        'officer_email': selectedOfficerEmail,
        'status': 'assigned',
        'notes': notesC.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Task assigned successfully')),
      );

      notesC.clear();
      setState(() {
        selectedReportId = null;
        selectedOfficerEmail = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign Tasks')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Dropdown for selecting report
                  DropdownButtonFormField<int>(
                    initialValue: selectedReportId,
                    decoration: const InputDecoration(labelText: 'Select Report'),
                    items: reports.map((r) {
                      return DropdownMenuItem<int>(
                        value: r['id'] as int,
                        child: Text('#${r['id']}  ${r['description']}'),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => selectedReportId = v),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Dropdown for selecting officer
                  DropdownButtonFormField<String>(
                    initialValue: selectedOfficerEmail,
                    decoration: const InputDecoration(labelText: 'Select Officer'),
                    items: officers.map((o) {
                      return DropdownMenuItem<String>(
                        value: o['email'] as String,
                        child: Text(o['name'] != null
                            ? "${o['name']} (${o['email']})"
                            : o['email'] as String),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => selectedOfficerEmail = v),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: notesC,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Notes (optional)'),
                  ),
                  const SizedBox(height: 12),

                  FilledButton(
                    onPressed: _save,
                    child: saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Assign'),
                  ),
                ],
              ),
            ),
    );
  }
}
