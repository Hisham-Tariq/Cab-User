import 'package:dio/dio.dart';
import '../models/direction.model.dart';
import '../../secrets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsController {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsController({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': GOOGLE_API_KEY,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      // print(response.data);
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
