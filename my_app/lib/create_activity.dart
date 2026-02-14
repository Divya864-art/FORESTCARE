import 'package:flutter/material.dart';

class CreateActivityPage extends StatelessWidget {
  const CreateActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Activity")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Activity Type", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            const Wrap(
              spacing: 10,
              children: [
                ChoiceChip(label: Text("Tree Planting"), selected: true),
                ChoiceChip(label: Text("Cleanup Drive"), selected: false),
                ChoiceChip(label: Text("Forest Monitoring"), selected: false),
              ],
            ),
            const SizedBox(height: 20),

            const TextField(decoration: InputDecoration(labelText: "Activity Title *")),
            const TextField(decoration: InputDecoration(labelText: "Description *")),
            const TextField(
              decoration: InputDecoration(labelText: "Maximum Participants"),
              keyboardType: TextInputType.number,
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Create Activity"),
            ),
          ],
        ),
      ),
    );
  }
}
