import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AllActivities extends StatefulWidget {
  const AllActivities({super.key});

  @override
  State<AllActivities> createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {
  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await Supabase.instance.client
        .from('real_time_data')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All User Activities')),
      body: FutureBuilder(
        future: _load(),
        builder: (_, snap) {
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
                leading: r['photo_url'] != null ? Image.network(r['photo_url'], width: 56, height: 56, fit: BoxFit.cover) : const Icon(Icons.image),
                title: Text(r['description'] ?? ''),
                subtitle: Text('${r['user_email'] ?? ''}\n$ts\n(${r['latitude']}, ${r['longitude']})'),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
