import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/location/location_bloc.dart';
import '../bloc/location/location_event.dart';
import '../bloc/location/location_state.dart';
import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_state.dart';
import '../models/vehicle.dart';
import '../utils/map_utils.dart';

class VehicleListScreen extends StatefulWidget {
  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';
  Vehicle? pickedUpVehicle;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Pickup'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Ready'),
            Tab(text: 'Getting Ready'),
            Tab(text: 'Dropped Off'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Vehicles',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoadInProgress) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is VehicleLoadSuccess) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildVehicleList(state.vehicles, 'ready'),
                      _buildVehicleList(state.vehicles, 'getting ready'),
                      _buildVehicleList(state.vehicles, 'dropped off'),
                    ],
                  );
                } else if (state is VehicleLoadFailure) {
                  return Center(child: Text('Failed to load vehicles'));
                } else {
                  return Center(child: Text('No vehicles available'));
                }
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: BlocBuilder<LocationBloc, LocationState>(
      //   builder: (context, state) {
      //     return FloatingActionButton.extended(
      //       onPressed: state is LocationTrackingInProgress && pickedUpVehicle != null
      //           ? () {
      //         context.read<LocationBloc>().add(StopLocationTracking());
      //         setState(() {
      //           pickedUpVehicle = null;
      //         });
      //       }
      //           : null,
      //       label: Text('Drop'),
      //       icon: Icon(Icons.check_circle),
      //       backgroundColor: state is LocationTrackingInProgress ? Colors.green : Colors.grey,
      //     );
      //   },
      // ),
    );
  }

  Widget _buildVehicleList(List<Vehicle> vehicles, String status) {
    final filteredVehicles = vehicles.where((vehicle) {
      return vehicle.status == status &&
          vehicle.model.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (filteredVehicles.isEmpty) {
      return Center(child: Text('No vehicles available'));
    }

    return ListView.builder(
      itemCount: filteredVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = filteredVehicles[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: Icon(
              Icons.directions_car,
              color: status == 'ready'
                  ? Colors.green
                  : status == 'getting ready'
                  ? Colors.orange
                  : Colors.grey,
            ),
            title: Text(
              vehicle.model,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Drop-Off: ${vehicle.dropOffLocation}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.map, color: Colors.blue),
                  onPressed: () {
                    openMap(vehicle.latitude, vehicle.longitude);
                  },
                ),
                if (pickedUpVehicle == vehicle && status != 'dropped off')
                  IconButton(
                    icon: Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () {
                      _showDropConfirmationDialog(vehicle);
                    },
                  ),
              ],
            ),
            onTap: () {
              if (status == 'ready' && pickedUpVehicle == null) {
                _showConfirmationDialog(vehicle);
              }
            },
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick Up Confirmation"),
          content: Text("Are you picking up this vehicle?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                openMap(vehicle.latitude, vehicle.longitude);
                setState(() {
                  pickedUpVehicle = vehicle;
                });
                context.read<LocationBloc>().add(StartLocationTracking());
              },
            ),
          ],
        );
      },
    );
  }

  void _showDropConfirmationDialog(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Drop Off Confirmation"),
          content: Text("Are you sure you want to mark this vehicle as dropped off?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                context.read<LocationBloc>().add(StopLocationTracking());
                setState(() {
                  pickedUpVehicle = null;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
