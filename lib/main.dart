import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/core/config/app_config.dart';
import 'package:keyring/core/di/bloc_providers.dart';
import 'package:keyring/core/di/repository_providers.dart';
import 'package:keyring/core/routes/app_routes.dart';
import 'core/storage/local_storage_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/theme.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorageService = await LocalStorageService.getInstance();
  final secureStorageService = SecureStorageService.instance;

  final accessToken = await secureStorageService.getAccessToken();
  final bool isLoggedIn = accessToken != null && accessToken.isNotEmpty;
  final initialRoute = isLoggedIn ? AppRoutes.keyring : AppRoutes.signIn;

  runApp(
    MultiRepositoryProvider(
      providers: repositoryProviders(
        localStorageService: localStorageService,
        secureStorageService: secureStorageService,
      ),
      child: MultiBlocProvider(
          providers: blocProviders,
          child: MyApp(initialRoute: initialRoute)
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: AppTheme.materialLightTheme,
      darkTheme: AppTheme.materialDarkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
