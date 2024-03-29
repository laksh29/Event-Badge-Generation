import 'package:event_batch/routes/routes_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Event Badge Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
    );
  }
}

/*
flutter build web --web-renderer canvaskit --release
firebase deploy

 */