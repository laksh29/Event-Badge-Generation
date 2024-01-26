import 'package:event_batch/flutter%20pulse/flutter_pulse_page.dart';
import 'package:event_batch/routes/routes_constants.dart';
import 'package:go_router/go_router.dart';

import '../demo/demo_page.dart';

final router = GoRouter(
  // initialLocation: demo,
  routes: [
    GoRoute(
      path: demo,
      builder: (context, state) => const DemoPage(),
    ),
    GoRoute(
      path: flutterPulse,
      builder: (context, state) => const FlutterPulsePage(),
    )
  ],
);
