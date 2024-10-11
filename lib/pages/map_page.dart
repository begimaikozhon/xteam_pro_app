import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xteam_pro_app/bloc/map_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    context
        .read<MarkerBloc>()
        .add(LoadMarkers()); // Загружаем метки при инициализации
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
  }

  void _addMarker(LatLng position) async {
    final title = await _showDialog('Введите название метки');
    if (title != null) {
      final description = await _showDialog('Введите описание метки');
      if (description != null) {
        context.read<MarkerBloc>().add(AddMarker(
            title, description, position.latitude, position.longitude));
      }
    }
  }

  Future<String?> _showDialog(String title) {
    String? input;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) {
              input = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(input);
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: BlocBuilder<MarkerBloc, MarkerState>(
        builder: (context, state) {
          if (state is MarkerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MarkerLoaded) {
            return GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(40.52828,
                    72.7985), // Начальное местоположение карты - город Ош
                zoom: 12, // Зум по умолчанию
              ),
              markers: state.markers, // Используем метки из состояния
              onTap: _addMarker, // Добавление новых меток при нажатии на карту
            );
          } else if (state is MarkerError) {
            return Center(
                child: Text(state.message)); // Отображаем сообщение об ошибке
          }
          return const Center(
              child: Text(
                  'Ошибка загрузки меток')); // На случай, если состояние неизвестно
        },
      ),
    );
  }
}
