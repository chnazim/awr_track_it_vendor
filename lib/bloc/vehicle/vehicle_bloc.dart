import 'package:awr_vendor_app/bloc/vehicle/vehicle_event.dart';
import 'package:awr_vendor_app/bloc/vehicle/vehicle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/vehicle.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc() : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<SearchVehicles>(_onSearchVehicles);
  }

  void _onLoadVehicles(LoadVehicles event, Emitter<VehicleState> emit) async {
    emit(VehicleLoadInProgress());
    try {
      // Simulate loading vehicles from an API or database
      final vehicles = [
        Vehicle(
          id: '1001',
          model: 'Toyota Camry',
          status: 'ready',
          dropOffLocation: 'Rigga Road, Deira',
          latitude: 25.2788,
          longitude: 55.3309,
        ),
        Vehicle(
          id: '1002',
          model: 'Toyota Corolla',
          status: 'ready',
          dropOffLocation: 'Rigga Road, Deira',
          latitude: 25.2788,
          longitude: 55.3309,
        ),Vehicle(
          id: '1003',
          model: 'Toyota Camry',
          status: 'getting ready',
          dropOffLocation: 'Rigga Road, Deira',
          latitude: 25.2788,
          longitude: 55.3309,
        ),
        Vehicle(
          id: '1003',
          model: 'Toyota Camry',
          status: 'dropped off',
          dropOffLocation: 'Rigga Road, Deira',
          latitude: 25.2788,
          longitude: 55.3309,
        ),
        // Add more vehicles here
      ];
      emit(VehicleLoadSuccess(vehicles));
    } catch (_) {
      emit(VehicleLoadFailure());
    }
  }

  void _onSearchVehicles(SearchVehicles event, Emitter<VehicleState> emit) {
    final currentState = state;
    if (currentState is VehicleLoadSuccess) {
      final vehicles = currentState.vehicles.where((vehicle) {
        return vehicle.model.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      emit(VehicleLoadSuccess(vehicles));
    }
  }
}