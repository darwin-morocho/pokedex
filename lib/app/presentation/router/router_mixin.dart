import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../my_app.dart';
import '../modules/home/view/home_view.dart';
import '../modules/pokemon/view/pokemon_view.dart';
import 'routes.dart';

mixin RouterMixin on State<MyApp> {
  GoRouter? _router;
  GoRouter get router {
    if (_router != null) {
      return _router!;
    }

    final routes = [
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
    ];

    /// check if the default routes have been overriden
    /// This is only for widget testing
    final overrideRoutes = widget.overrideRoutes;
    if (overrideRoutes?.isNotEmpty ?? false) {
      final names = overrideRoutes!.map(
        (e) => e.name,
      );
      routes.removeWhere(
        (element) {
          final name = element.name;
          if (name != null) {
            return names.contains(name);
          }
          return false;
        },
      );
      routes.addAll(overrideRoutes);
    }

    _router = GoRouter(
      initialLocation: widget.initialRoute ?? '/',
      routes: routes,
    );
    return _router!;
  }
}
