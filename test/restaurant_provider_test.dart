import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockApiService extends Mock implements ApiServices {}

void main() {
  late MockApiService apiService;
  late RestaurantListProvider listProvider;
  final RestaurantListResponse successResponse = RestaurantListResponse(
    error: false,
    message: "success",
    restaurants: const [],
  );
  final RestaurantListResponse failedResponse = RestaurantListResponse(
    error: true,
    message: "failed",
    restaurants: const [],
  );

  setUp(() {
    apiService = MockApiService();
    listProvider = RestaurantListProvider(apiService);
  });
  group("Restaurant List Test", () {
    test('Provider return RestaurantListNoneState when init', () {
      final initState = listProvider.resultState;

      expect(initState, isA<RestaurantListNoneState>());
    });
    test('Provider return successful API fetch with result', () async {
      when(
        () => apiService.getRestaurantList(),
      ).thenAnswer((value) async => successResponse);

      final states = [];
      listProvider.addListener(() {
        states.add(listProvider.resultState);
      });

      await listProvider.fetchRestaurantList();

      expect(states.first, isA<RestaurantListLoadingState>());
      expect(states.last, isA<RestaurantListLoadedState>());

      final loaded = listProvider.resultState as RestaurantListLoadedState;
      expect(loaded.data, equals(successResponse.restaurants));
    });
    test('Provider return failed API fetch with error message', () async {
      when(
        () => apiService.getRestaurantList(),
      ).thenAnswer((value) async => failedResponse);

      final states = [];
      listProvider.addListener(() {
        states.add(listProvider.resultState);
      });

      await listProvider.fetchRestaurantList();

      expect(states.first, isA<RestaurantListLoadingState>());
      expect(states.last, isA<RestaurantListErrorState>());

      final loaded = listProvider.resultState as RestaurantListErrorState;
      expect(loaded.error, equals("Failed to fetch API!"));
    });
  });
}
