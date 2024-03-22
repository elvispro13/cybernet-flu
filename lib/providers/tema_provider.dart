import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

final orientacionProvider = StateProvider<List<DeviceOrientation>>(
  (ref) => [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ],
);
