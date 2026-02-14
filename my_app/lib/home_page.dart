import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Hello, divya!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Let's make our forests healthier today"),
            const SizedBox(height: 16),

            // Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("🌳 Forest Care Initiative",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text("1250 pts",
                      style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Banner
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                    image: AssetImage("assets/forest.jpg"), fit: BoxFit.cover),
              ),
              child: const Center(
                child: Text(
                  "Forest Care Initiative\nJoin thousands protecting our forests",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionCard(icon: Icons.map, label: "Map"),
                ActionCard(icon: Icons.qr_code_scanner, label: "QR Scanner"),
                ActionCard(icon: Icons.event, label: "Activity"),
                ActionCard(icon: Icons.person, label: "Profile"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const ActionCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 28, backgroundColor: Colors.green, child: Icon(icon, color: Colors.white)),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
