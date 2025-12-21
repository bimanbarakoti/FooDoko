import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _marker = const LatLng(27.7172, 85.3240); // default Kathmandu
  String _address = "Tap to select location";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _loading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _loading = false);
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() => _loading = false);
      return;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _moveMarker(LatLng(pos.latitude, pos.longitude));
  }

  Future<void> _moveMarker(LatLng latlng) async {
    setState(() {
      _marker = latlng;
      _loading = true;
    });
    try {
      final placemarks = await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
      final p = placemarks.first;
      final address = [
        if (p.street != null && p.street!.isNotEmpty) p.street,
        if (p.locality != null && p.locality!.isNotEmpty) p.locality,
        if (p.subAdministrativeArea != null && p.subAdministrativeArea!.isNotEmpty) p.subAdministrativeArea,
        if (p.country != null && p.country!.isNotEmpty) p.country,
      ].join(', ');
      setState(() {
        _address = address;
      });
    } catch (e) {
      setState(() {
        _address = "Selected location (lat: ${latlng.latitude.toStringAsFixed(5)}, lng: ${latlng.longitude.toStringAsFixed(5)})";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }

    final GoogleMapController c = await _controller.future;
    await c.animateCamera(CameraUpdate.newLatLng(latlng));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _marker, zoom: 15),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (latlng) => _moveMarker(latlng),
            markers: {
              Marker(markerId: const MarkerId('picked'), position: _marker, draggable: true, onDragEnd: (pos) => _moveMarker(pos)),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_loading ? "Locating..." : "Selected Address", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(_address, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "address": _address,
                  "lat": _marker.latitude,
                  "lng": _marker.longitude,
                });
              },
              child: const Text("Confirm Location"),
            ),
          )
        ],
      ),
    );
  }
}
