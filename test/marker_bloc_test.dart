import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:xteam_pro_app/bloc/map_bloc.dart';

// Моки для Firestore
class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockDocumentSnapshot extends Mock implements QueryDocumentSnapshot {
  @override
  Map<String, dynamic> data() {
    return {
      'title': 'Test Marker',
      'description': 'Test Description',
      'latitude': 40.52828,
      'longitude': 72.7985,
    };
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  group('MarkerBloc Tests', () {
    late MarkerBloc markerBloc;
    late MockCollectionReference mockCollectionReference;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockDocumentSnapshot mockDocumentSnapshot;

    setUp(() {
      mockCollectionReference = MockCollectionReference();
      mockQuerySnapshot = MockQuerySnapshot();
      mockDocumentSnapshot = MockDocumentSnapshot();

      markerBloc = MarkerBloc();

      when(mockCollectionReference.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockDocumentSnapshot]);
      when(mockDocumentSnapshot.id).thenReturn('test_marker_id');
    });

    test('Load markers emits MarkerLoaded state', () async {
      markerBloc.add(LoadMarkers());
      await expectLater(
          markerBloc.stream,
          emitsInOrder([
            isA<MarkerLoading>(),
            isA<MarkerLoaded>(),
          ]));
    });

    test('Error when loading markers emits MarkerError', () async {
      when(mockCollectionReference.get())
          .thenThrow(Exception('Failed to load'));
      markerBloc.add(LoadMarkers());
      await expectLater(
          markerBloc.stream,
          emitsInOrder([
            isA<MarkerLoading>(),
            isA<MarkerError>(),
          ]));
    });
  });
}
