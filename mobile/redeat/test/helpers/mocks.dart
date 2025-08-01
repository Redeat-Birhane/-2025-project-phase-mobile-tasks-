import 'package:mockito/mockito.dart';
import 'package:my_first_app/data/datasources/product_remote_data_source.dart';
import 'package:my_first_app/data/datasources/product_local_data_source.dart';
import 'package:my_first_app/core/network/network_info.dart';


class MockProductRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class MockProductLocalDataSource extends Mock implements ProductLocalDataSource {}


class MockNetworkInfo extends Mock implements NetworkInfo {}
