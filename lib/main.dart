import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dukkantek/repositories/auth/repository/authentication_repository.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  await runZonedGuarded(() async {

    WidgetsFlutterBinding.ensureInitialized();


    runApp(App(
      authenticationRepository: AuthenticationRepository(),
      connectivity: Connectivity(),
    ));
  }, (error, stackTrace) {
  });
}
