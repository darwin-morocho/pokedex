import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../my_app.dart';
import '../modules/home/view/home_view.dart';
import '../modules/pokemon/view/pokemon_view.dart';
import 'routes.dart';

mixin RouterMixin on State<MyApp> {
  GoRouter get router => _router;

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: Routes.home,
        builder: (_, __) => const HomeView(),
      ),
      GoRoute(
        path: '/pokemon/:id',
        name: Routes.pokemon,
        builder: (_, state) {
          final id = state.params['id'] as String;
          assert(id.isNotEmpty);

          return PokemonView(
            id: id,
          );
        },
      ),
    ],
  );
}
