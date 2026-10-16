import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/core/config/app_config.dart';
import 'package:keyring/core/di/bloc_providers.dart';
import 'package:keyring/core/di/repository_providers.dart';
import 'package:keyring/core/routes/app_routes.dart';
import 'core/storage/local_storage_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/theme.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Notification On Background: $message");
  // final notificationService = NotificationService();
  // await notificationService.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


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

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    // context.read<NotificationService>().notificationInitCall();
    // log("Stored Fcm Token:\n${context.read<LocalStorageService>().getString(LocalSto.fcmToken)}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: AppTheme.materialLightTheme,
      darkTheme: AppTheme.materialDarkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: widget.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
