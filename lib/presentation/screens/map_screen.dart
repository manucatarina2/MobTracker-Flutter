import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import '../../core/constants/app_colors.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  latlong.LatLng? _currentPosition;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = latlong.LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentPosition!, 14.0);
  }

  void _centerOnUser() {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Confiabilidade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnUser,
          ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition!,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mobtracker.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    Marker(
                      point: const latlong.LatLng(-23.5505, -46.6333),
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet('Parada Central', AppColors.markerMedium);
                        },
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.markerMedium,
                          size: 30,
                        ),
                      ),
                    ),
                    Marker(
                      point: const latlong.LatLng(-23.5605, -46.6433),
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet('Parada Paulista', AppColors.markerHigh);
                        },
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.markerHigh,
                          size: 30,
                        ),
                      ),
                    ),
                    Marker(
                      point: const latlong.LatLng(-23.5405, -46.6233),
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet('Parada Jardins', AppColors.markerLow);
                        },
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.markerLow,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _showBottomSheet(String title, Color color) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.location_on, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Confiabilidade: 75%'),
            const SizedBox(height: 8),
            const Text('Média de atraso: 12 min'),
            const SizedBox(height: 8),
            const Text('Últimos relatos: 15'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Fechar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}