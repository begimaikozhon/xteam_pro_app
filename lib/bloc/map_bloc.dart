import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MarkerEvent {}

class LoadMarkers extends MarkerEvent {}

class AddMarker extends MarkerEvent {
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  AddMarker(this.title, this.description, this.latitude, this.longitude);
}

abstract class MarkerState {}

class MarkerInitial extends MarkerState {}

class MarkerLoading extends MarkerState {}

class MarkerLoaded extends MarkerState {
  final Set<Marker> markers;

  MarkerLoaded(this.markers);
}

class MarkerError extends MarkerState {
  final String message;

  MarkerError(this.message);
}
// lib/bloc/marker_bloc.dart

class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  final CollectionReference _markersCollection =
      FirebaseFirestore.instance.collection('markers');

  MarkerBloc() : super(MarkerInitial()) {
    on<LoadMarkers>((event, emit) async {
      emit(MarkerLoading());
      try {
        final querySnapshot = await _markersCollection.get();
        final markers = <Marker>{};

        for (var doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final marker = Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(data['latitude'], data['longitude']),
            infoWindow: InfoWindow(
              title: data['title'],
              snippet: data['description'],
            ),
          );
          markers.add(marker);
        }

        emit(MarkerLoaded(markers));
      } catch (e) {
        emit(MarkerError('Ошибка при загрузке меток: $e'));
      }
    });

    on<AddMarker>((event, emit) async {
      try {
        final newMarkerData = {
          'title': event.title,
          'description': event.description,
          'latitude': event.latitude,
          'longitude': event.longitude,
        };

        await _markersCollection.add(newMarkerData);
        add(LoadMarkers()); // Перезагружаем метки после добавления новой
      } catch (e) {
        emit(MarkerError('Ошибка при добавлении метки: $e'));
      }
    });
  }
}
