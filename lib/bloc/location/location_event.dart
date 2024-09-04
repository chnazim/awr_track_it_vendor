import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartLocationTracking extends LocationEvent {}

class StopLocationTracking extends LocationEvent {}

class LocationUpdated extends LocationEvent {
  final Position position;

  LocationUpdated({required this.position});

  @override
  List<Object> get props => [position];
}