import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../all_activities.dart';
import '../../admin_map.dart';
import '../../assign_tasks.dart';

class HomeAdmin extends StatelessWidget {
  final String adminEmail;
  const HomeAdmin({super.key, required this.adminEmail});

  void _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forest Care - Admin'), actions: [
        IconButton(onPressed: () => _logout(context), icon: const Icon(Icons.logout))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FilledButton.icon(
            icon: const Icon(Icons.list_alt),
            label: const Text('All User Activities'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllActivities())),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.map),
            label: const Text('Map (Reports + Police Stations)'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMap())),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.assignment_ind),
            label: const Text('Assign Tasks to Officers'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssignTasks())),
          ),
        ]),
      ),
    );
  }
}
