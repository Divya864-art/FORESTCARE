import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class MyActivitiesPage extends StatefulWidget {
  final String userEmail;
  const MyActivitiesPage({super.key, required this.userEmail});

  @override
  State<MyActivitiesPage> createState() => _MyActivitiesState();
}

class _MyActivitiesState extends State<MyActivitiesPage> {
  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await Supabase.instance.client
        .from('real_time_data')
        .select()
        .eq('user_email', widget.userEmail)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Activities')),
      body: FutureBuilder(
        future: _load(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data != null
      ? List<Map<String, dynamic>>.from(snap.data as List)
      : <Map<String, dynamic>>[];

          if (data.isEmpty) return const Center(child: Text('No activities'));
          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = data[i];
              final when = DateTime.tryParse(r['created_at'] ?? '');
              final ts = when == null ? '' : DateFormat('yyyy-MM-dd HH:mm').format(when);
              return ListTile(
                leading: r['photo_url'] != null ? Image.network(r['photo_url'], width: 56, height: 56, fit: BoxFit.cover) : const Icon(Icons.image_not_supported),
                title: Text(r['description'] ?? ''),
                subtitle: Text('$ts\n${r['location_text'] ?? ''}\n(${r['latitude']}, ${r['longitude']})'),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
