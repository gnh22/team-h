import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:critter_app/viewmodels/critter_viewmodel.dart';
import 'package:critter_app/models/critter.dart';
import 'package:critter_app/services/api_service.dart';
import 'package:critter_app/storage/preferences_service.dart';

// Generate mocks with: flutter pub run build_runner build
@GenerateMocks([ApiService, PreferencesService])
import 'view_model_test.mocks.dart';

void main() {
  late MockApiService mockApi;
  late MockPreferencesService mockPrefs;
  late CritterViewModel viewModel;

  setUp(() {
    mockApi = MockApiService();
    mockPrefs = MockPreferencesService();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('CritterViewModel Initialization', () {
    test('initializes with default values', () {
      viewModel = CritterViewModel(api: mockApi, prefs: mockPrefs);

      expect(viewModel.allCritters, isEmpty);
      expect(viewModel.critters, isEmpty);
      expect(viewModel.loading, false);
      expect(viewModel.error, null);
      expect(viewModel.hemisphere, 'northern');
    });

    test('initNow loads hemisphere and fetches critters', () async {
      when(mockPrefs.loadHemisphere()).thenAnswer((_) async => 'southern');
      when(mockApi.fetchCritters('bugs')).thenAnswer((_) async => []);
      when(mockApi.fetchCritters('fish')).thenAnswer((_) async => []);

      viewModel = CritterViewModel(api: mockApi, prefs: mockPrefs);
      await viewModel.initNow();

      expect(viewModel.hemisphere, 'southern');
      verify(mockApi.fetchCritters('bugs')).called(1);
      verify(mockApi.fetchCritters('fish')).called(1);
    });
  });

  group('fetchAll', () {
    test('successfully fetches and combines bugs and fish', () async {
      final bugs = [
        Critter(
          name: 'Butterfly',
          imageUrl: 'https://example.com/butterfly.png',
          monthsNorthern: [1, 2, 3],
          monthsSouthern: [7, 8, 9],
          allYear: false,
          time: 'All day',
          location: 'Flying',
          sellNook: 160,
        ),
      ];
      final fish = [
        Critter(
          name: 'Bass',
          imageUrl: 'https://example.com/bass.png',
          monthsNorthern: [4, 5, 6],
          monthsSouthern: [10, 11, 12],
          allYear: false,
          time: '8 AM – 5 PM',
          location: 'River',
          sellNook: 400,
        ),
      ];

      when(mockApi.fetchCritters('bugs')).thenAnswer((_) async => bugs);
      when(mockApi.fetchCritters('fish')).thenAnswer((_) async => fish);

      viewModel = CritterViewModel(api: mockApi, prefs: mockPrefs);
      await viewModel.fetchAll();

      expect(viewModel.allCritters.length, 2);
      expect(viewModel.loading, false);
      expect(viewModel.error, null);
    });

    test('sets error on fetch failure', () async {
      when(mockApi.fetchCritters('bugs'))
          .thenThrow(Exception('Network error'));

      viewModel = CritterViewModel(api: mockApi, prefs: mockPrefs);
      await viewModel.fetchAll();

      expect(viewModel.error, isNotNull);
      expect(viewModel.error, contains('Network error'));
      expect(viewModel.loading, false);
    });

    test('sets loading state correctly', () async {
      when(mockApi.fetchCritters('bugs')).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        return [];
      });
      when(mockApi.fetchCritters('fish')).thenAnswer((_) async => []);

      viewModel = CritterViewModel(api: mockApi, prefs: mockPrefs);
      
      final future = viewModel.fetchAll();
      expect(viewModel.loading, true);
      
      await future;
      expect(viewModel.loading, false);
    });
  });

  group('applyFilters', () {
    setUp(() {
      viewModel = CritterViewModel(api: mockApi, prefs: mockPrefs);
    });

    test('filters critters by current month (northern hemisphere)', () {
      viewModel.hemisphere = 'northern';
      viewModel.current = DateTime(2024, 3, 15); // March
      viewModel.allCritters = [
        Critter(
          name: 'Spring Bug',
          imageUrl: 'https://example.com/spring.png',
          monthsNorthern: [3, 4, 5],
          monthsSouthern: [9, 10, 11],
          allYear: false,
          time: 'All day',
          location: 'Ground',
          sellNook: 200,
        ),
        Critter(
          name: 'Summer Bug',
          imageUrl: 'https://example.com/summer.png',
          monthsNorthern: [6, 7, 8],
          monthsSouthern: [12, 1, 2],
          allYear: false,
          time: 'All day',
          location: 'Trees',
          sellNook: 300,
        ),
      ];

      viewModel.applyFilters();

      expect(viewModel.critters.length, 1);
      expect(viewModel.critters.first.name, 'Spring Bug');
    });

    test('filters critters by current month (southern hemisphere)', () {
      viewModel.hemisphere = 'southern';
      viewModel.current = DateTime(2024, 9, 15); // September
      viewModel.allCritters = [
        Critter(
          name: 'Spring Bug',
          imageUrl: 'https://example.com/spring.png',
          monthsNorthern: [3, 4, 5],
          monthsSouthern: [9, 10, 11],
          allYear: false,
          time: 'All day',
          location: 'Ground',
          sellNook: 200,
        ),
        Critter(
          name: 'Summer Bug',
          imageUrl: 'https://example.com/summer.png',
          monthsNorthern: [6, 7, 8],
          monthsSouthern: [12, 1, 2],
          allYear: false,
          time: 'All day',
          location: 'Trees',
          sellNook: 300,
        ),
      ];

      viewModel.applyFilters();

      expect(viewModel.critters.length, 1);
      expect(viewModel.critters.first.name, 'Spring Bug');
    });

    test('filters critters by time range', () {
      viewModel.current = DateTime(2024, 3, 15, 10, 0); // 10 AM
      viewModel.hour = 10;
      viewModel.allCritters = [
        Critter(
          name: 'Morning Bug',
          imageUrl: 'https://example.com/morning.png',
          monthsNorthern: [3],
          monthsSouthern: [9],
          allYear: false,
          time: '8 AM – 12 PM',
          location: 'Flowers',
          sellNook: 150,
        ),
        Critter(
          name: 'Evening Bug',
          imageUrl: 'https://example.com/evening.png',
          monthsNorthern: [3],
          monthsSouthern: [9],
          allYear: false,
          time: '6 PM – 10 PM',
          location: 'Trees',
          sellNook: 250,
        ),
      ];

      viewModel.applyFilters();

      expect(viewModel.critters.length, 1);
      expect(viewModel.critters.first.name, 'Morning Bug');
    });

    test('includes critters available all day', () {
      viewModel.current = DateTime(2024, 3, 15, 10, 0);
      viewModel.hour = 10;
      viewModel.allCritters = [
        Critter(
          name: 'All Day Bug',
          imageUrl: 'https://example.com/allday.png',
          monthsNorthern: [3],
          monthsSouthern: [9],
          allYear: false,
          time: 'All day',
          location: 'Ground',
          sellNook: 500,
        ),
      ];

      viewModel.applyFilters();

      expect(viewModel.critters.length, 1);
      expect(viewModel.critters.first.name, 'All Day Bug');
    });
  });

  group('_isAvailableAtHour', () {
    setUp(() {
      viewModel = CritterViewModel(api: mockApi, prefs: mockPrefs);
    });

    test('returns true for "all day" time ranges', () {
      expect(viewModel.applyTimeFilter('All day', 10), true);
      expect(viewModel.applyTimeFilter('ALL DAY', 23), true);
    });

    test('handles daytime ranges correctly', () {
      expect(viewModel.applyTimeFilter('8 AM – 5 PM', 10), true);
      expect(viewModel.applyTimeFilter('8 AM – 5 PM', 8), true);
      expect(viewModel.applyTimeFilter('8 AM – 5 PM', 17), false);
      expect(viewModel.applyTimeFilter('8 AM – 5 PM', 6), false);
    });

    test('handles overnight ranges correctly', () {
      expect(viewModel.applyTimeFilter('9 PM – 4 AM', 22), true);
      expect(viewModel.applyTimeFilter('9 PM – 4 AM', 2), true);
      expect(viewModel.applyTimeFilter('9 PM – 4 AM', 4), false);
      expect(viewModel.applyTimeFilter('9 PM – 4 AM', 10), false);
    });

    test('handles noon and midnight edge cases', () {
      expect(viewModel.applyTimeFilter('12 PM – 6 PM', 12), true);
      expect(viewModel.applyTimeFilter('12 PM – 6 PM', 14), true);
      expect(viewModel.applyTimeFilter('11 PM – 12 AM', 23), true);
      expect(viewModel.applyTimeFilter('11 PM – 12 AM', 0), false);
    });

    test('returns true for invalid time format', () {
      expect(viewModel.applyTimeFilter('Invalid format', 10), true);
      expect(viewModel.applyTimeFilter('', 10), true);
    });
  });

  group('Clock functionality', () {
    test('hour and minute are set from current time', () {
      viewModel = CritterViewModel(api: mockApi, prefs: mockPrefs);
      
      expect(viewModel.hour, isA<int>());
      expect(viewModel.minute, isA<int>());
      expect(viewModel.hour, greaterThanOrEqualTo(0));
      expect(viewModel.hour, lessThan(24));
      expect(viewModel.minute, greaterThanOrEqualTo(0));
      expect(viewModel.minute, lessThan(60));
    });
  });
}