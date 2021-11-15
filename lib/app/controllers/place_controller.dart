import 'package:dio/dio.dart';
import '../models/place.model.dart';
import '../../secrets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceController {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?';

  final Dio _dio;

  PlaceController({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Place>> getNearbyPlaces({
    required LatLng userLocation,
    required String keyword,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'location': '${userLocation.latitude},${userLocation.longitude}',
        'radius': 10000,
        'key': GOOGLE_API_KEY,
        'keyword': keyword,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      List<Place> places = [];
      response.data['results'].forEach((place) {
        places.add(
          Place(
            name: place['name'],
            address: place['vicinity'],
            location: LatLng(
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng'],
            ),
            norteast: LatLng(
              place['geometry']['viewport']['northeast']['lat'],
              place['geometry']['viewport']['northeast']['lng'],
            ),
            southwest: LatLng(
              place['geometry']['viewport']['southwest']['lat'],
              place['geometry']['viewport']['southwest']['lng'],
            ),
            placeId: place['place_id'],
            types: place['types'],
          ),
        );
      });
      return places;
    }
    return [];
    // return null;
  }
}
