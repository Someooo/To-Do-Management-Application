import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:my_template/core/services/network_service.dart';
import 'package:my_template/core/widgets/connectivity_banner_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    GetIt.instance.reset();
    GetIt.instance.registerSingleton<NetworkService>(NetworkService());
  });

  testWidgets('ConnectivityBannerWidget shows banner when offline',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ConnectivityBannerWidget(),
              Text('App Body'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Please check your internet connection.'), findsNothing);

    final networkService = GetIt.instance<NetworkService>();
    networkService.isConnectedNotifier.value = false;
    await tester.pumpAndSettle();

    expect(find.text('Please check your internet connection.'), findsOneWidget);

    networkService.isConnectedNotifier.value = true;
    await tester.pumpAndSettle();

    expect(find.text('Please check your internet connection.'), findsNothing);
  });
}
