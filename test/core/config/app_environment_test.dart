import 'package:flutter_test/flutter_test.dart';
import 'package:rabbit_farm_mobileapp/core/config/app_environment.dart';

void main() {
  test('provides a normalized API base URL', () {
    expect(AppEnvironment.apiBaseUrl, isNotEmpty);
    expect(AppEnvironment.apiBaseUrl, isNot(endsWith('/')));
  });
}
