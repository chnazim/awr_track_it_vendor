import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'location_event.dart';
import 'location_state.dart';


class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _timer;

  LocationBloc() : super(LocationInitial()) {
    on<StartLocationTracking>(_onStartLocationTracking);
    on<StopLocationTracking>(_onStopLocationTracking);
    on<LocationUpdated>(_onLocationUpdated);
  }

  void _onStartLocationTracking(StartLocationTracking event, Emitter<LocationState> emit) async {
    emit(LocationTrackingInProgress());

    // Request permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(LocationTrackingFailed('Location services are disabled.'));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(LocationTrackingFailed('Location permissions are denied.'));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(LocationTrackingFailed('Location permissions are permanently denied.'));
      return;
    }

    // Start location updates
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      add(LocationUpdated(position: position));
    });

    // Send location to API every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      final position = await Geolocator.getCurrentPosition();
      await _sendLocationToApi(position);
    });
  }

  void _onStopLocationTracking(StopLocationTracking event, Emitter<LocationState> emit) {
    _positionStreamSubscription?.cancel();
    _timer?.cancel();
    emit(LocationTrackingStopped());
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<LocationState> emit) {
    emit(LocationTrackingInProgress(position: event.position));
  }

  Future<void> _sendLocationToApi(Position position) async {
    final url = 'https://domain.com/update-location';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update location');
      }
    } catch (error) {
      // Handle API call failure
    }
  }
}