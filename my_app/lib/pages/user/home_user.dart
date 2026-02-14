import 'package:flutter/material.dart';
import 'package:my_app/alert_page.dart';
import 'package:my_app/my_activities.dart';
import 'package:my_app/add_activity.dart';
import 'package:my_app/capture_incident.dart';

import 'package:my_app/profile.dart'; // ✅ Import Profile Page

class HomeUser extends StatefulWidget {
  final String userEmail;
  const HomeUser({super.key, required this.userEmail});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      // ✅ HOME TAB with Quick Actions
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, ${widget.userEmail} 👋",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            const Text("Quick Actions",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AddActivityPage(userEmail: widget.userEmail)),
                    );
                  },
                  icon: const Icon(Icons.add_task),
                  label: const Text("Add Activity"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              CaptureIncidentPage(officerId: widget.userEmail)),
                    );
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Capture Incident"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AlertPage(userEmail: widget.userEmail)),
                    );
                  },
                  icon: const Icon(Icons.warning_amber_rounded,
                      color: Colors.red),
                  label: const Text("Send Alert"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // ✅ Other Tabs
      
      AddActivityPage(userEmail: widget.userEmail),    
      MyActivitiesPage(userEmail: widget.userEmail),
      CaptureIncidentPage(officerId: widget.userEmail),
      AlertPage(userEmail: widget.userEmail),
      const ProfilePage(), // ✅ Added Profile Page
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('User - ${widget.userEmail}')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Activity"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "My Activities"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Capture"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Alert"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"), // ✅ New Tab
        ],
      ),
    );
  }
}
