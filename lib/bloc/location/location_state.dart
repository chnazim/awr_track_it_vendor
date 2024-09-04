import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationTrackingInProgress extends LocationState {
  final Position? position;

  LocationTrackingInProgress({this.position});

  @override
  List<Object> get props => [position!];
}

class LocationTrackingStopped extends LocationState {}

class LocationTrackingFailed extends LocationState {
  final String error;

  LocationTrackingFailed(this.error);

  @override
  List<Object> get props => [error];
}
