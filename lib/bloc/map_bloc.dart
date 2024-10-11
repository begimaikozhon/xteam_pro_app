import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Абстрактный класс для событий меток
abstract class MarkerEvent {}

class LoadMarkers extends MarkerEvent {}

class AddMarker extends MarkerEvent {
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  AddMarker(this.title, this.description, this.latitude, this.longitude);
}

// Абстрактный класс для состояний меток
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


// BLoC для управления состоянием меток
class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  final CollectionReference _markersCollection =
      FirebaseFirestore.instance.collection('markers'); // Коллекция для меток

  MarkerBloc() : super(MarkerInitial()) {
    // Обработка события LoadMarkers
    on<LoadMarkers>((event, emit) async {
      emit(MarkerLoading()); // Устанавливаем состояние загрузки
      try {
        final querySnapshot = await _markersCollection.get(); // Загружаем метки
        final markers = <Marker>{};

        // Обработка загруженных документов
        for (var doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          // Проверяем наличие данных и их тип
          double latitude = data['latitude'] is double ? data['latitude'] : 0.0;
          double longitude = data['longitude'] is double ? data['longitude'] : 0.0;

          if (latitude == 0.0 || longitude == 0.0) {
            emit(MarkerError('Ошибка: неверные координаты для метки ${doc.id}.'));
            continue; // Пропускаем эту метку
          }

          final marker = Marker(
            markerId: MarkerId(doc.id), // Уникальный идентификатор метки
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: data['title'], // Заголовок для окна информации
              snippet: data['description'], // Описание метки
            ),
          );
          markers.add(marker); // Добавляем метку в набор
        }

        emit(MarkerLoaded(markers)); // Устанавливаем состояние с загруженными метками
      } catch (e) {
        emit(MarkerError('Ошибка при загрузке меток: $e')); // Устанавливаем состояние ошибки
      }
    });

    // Обработка события AddMarker
    on<AddMarker>((event, emit) async {
      try {
        final newMarkerData = {
          'title': event.title, // Заголовок метки
          'description': event.description, // Описание метки
          'latitude': event.latitude, // Широта
          'longitude': event.longitude, // Долгота
        };

        await _markersCollection.add(newMarkerData); // Добавляем новую метку в Firestore
        add(LoadMarkers()); // Перезагружаем метки после добавления новой
      } catch (e) {
        emit(MarkerError('Ошибка при добавлении метки: $e')); // Устанавливаем состояние ошибки
      }
    });
  }
}