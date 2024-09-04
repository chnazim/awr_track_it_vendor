
import 'package:awr_vendor_app/screens/vehicle_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/location/location_bloc.dart';
import 'bloc/vehicle/vehicle_bloc.dart';
import 'bloc/vehicle/vehicle_event.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VehicleBloc>(
          create: (context) => VehicleBloc()..add(LoadVehicles()),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Vehicle Pickup App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: VehicleListScreen(),
      ),
    );
  }
}
