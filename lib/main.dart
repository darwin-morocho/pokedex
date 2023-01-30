import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/core/env.dart';
import 'app/inject_repositories.dart';
import 'app/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  injectRepositories(
    baseUrl: Env.baseApiUrl,
    client: Client(),
  );
  runApp(
    const MyApp(),
  );
}
