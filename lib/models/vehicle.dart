import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String model;
  final String status; // "ready", "getting ready", "dropped off"
  bool isPickedUp;
  final String dropOffLocation;
  final double latitude;
  final double longitude;

  Vehicle({
    required this.id,
    required this.model,
    required this.status,
    this.isPickedUp = false,
    required this.dropOffLocation,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props =>
      [id, model, status, dropOffLocation, latitude, longitude];
}
