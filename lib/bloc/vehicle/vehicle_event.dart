import 'package:equatable/equatable.dart';

abstract class VehicleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVehicles extends VehicleEvent {}

class SearchVehicles extends VehicleEvent {
  final String query;

  SearchVehicles(this.query);

  @override
  List<Object> get props => [query];
}