import 'package:equatable/equatable.dart';

import '../../models/vehicle.dart';

abstract class VehicleState extends Equatable {
  @override
  List<Object> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoadInProgress extends VehicleState {}

class VehicleLoadSuccess extends VehicleState {
  final List<Vehicle> vehicles;

  VehicleLoadSuccess(this.vehicles);

  @override
  List<Object> get props => [vehicles];
}

class VehicleLoadFailure extends VehicleState {}