import 'package:flutter/material.dart';
import 'package:my_app/report_incident.dart'; // import your incident page

class AlertPage extends StatelessWidget {
  final String userEmail;

  const AlertPage({super.key, required this.userEmail});

  void _sendAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🚨 Alert sent by $userEmail to authorities")),
    );
  }

  void _openReportIncident(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportIncidentPage(userEmail: userEmail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Alert")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Report suspicious or illegal activities in the forest area.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _sendAlert(context),
              child: const Text("Send Quick Alert"),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => _openReportIncident(context),
              icon: const Icon(Icons.report),
              label: const Text("Go to Detailed Report"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
