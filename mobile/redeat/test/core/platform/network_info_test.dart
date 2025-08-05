import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info_test.mocks.dart';


@GenerateMocks([InternetConnectionChecker])
void main() {
  late MockInternetConnectionChecker mockConnectionChecker;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
  });

  test('should check network connection', () async {
    when(mockConnectionChecker.hasConnection).thenAnswer((_) async => true);

    final result = await mockConnectionChecker.hasConnection;
    expect(result, true);
  });
}
