import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminMap extends StatefulWidget {
  final LatLng? userCenter; // optional starting point

  const AdminMap({
    super.key,
    this.userCenter,
  });

  @override
  State<AdminMap> createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  late Future<List<Map<String, dynamic>>> _futureReports;

  // 🚓 Static police stations
  final policeStations = const [
    {'name': 'Central Police Station', 'lat': 28.6139, 'lng': 77.2090},
    {'name': 'North Range PS', 'lat': 28.7041, 'lng': 77.1025},
    {'name': 'South Range PS', 'lat': 28.4595, 'lng': 77.0266},
    {'name': 'East Range PS', 'lat': 28.6465, 'lng': 77.3209},
  ];

  Future<List<Map<String, dynamic>>> _loadReports() async {
    final rows = await Supabase.instance.client
        .from('real_time_data')
        .select('id, description, latitude, longitude, user_email, created_at');
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  void initState() {
    super.initState();
    _futureReports = _loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Map')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = snapshot.data ?? [];

          // 🔴 Report markers
          final reportMarkers = reports
              .where((r) => r['latitude'] != null && r['longitude'] != null)
              .map((r) {
            final lat = (r['latitude'] as num).toDouble();
            final lng = (r['longitude'] as num).toDouble();
            final desc = r['description'] ?? 'No description';
            final user = r['user_email'] ?? 'Unknown';
            final time = (r['created_at'] ?? '').toString();

            return Marker(
              point: LatLng(lat, lng),
              width: 44,
              height: 44,
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Report Details'),
                    content: Text("📍 $desc\n👤 $user\n🕒 $time"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      )
                    ],
                  ),
                ),
                child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
            );
          }).toList();

          // 🚓 Police station markers
          final policeMarkers = policeStations.map((ps) {
            return Marker(
              point: LatLng(ps['lat'] as double, ps['lng'] as double),
              width: 44,
              height: 44,
              child: Tooltip(
                message: ps['name'] as String,
                child: const Icon(Icons.local_police,
                    color: Colors.blue, size: 34),
              ),
            );
          }).toList();

          final markers = [...reportMarkers, ...policeMarkers];

          // 📍 Default center
          final center = widget.userCenter ??
              (markers.isNotEmpty
                  ? markers.first.point
                  : const LatLng(20.5937, 78.9629)); // India

          return FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.forestcare',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
