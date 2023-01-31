import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/app/domain/either/either.dart';
import 'package:pokedex/app/domain/failures/http_request/http_request_failure.dart';
import 'package:pokedex/app/domain/models/pokemon/pokemon.dart';
import 'package:pokedex/app/domain/repositories/pokedex_repository.dart';
import 'package:pokedex/app/my_app.dart';
import 'package:pokedex/app/presentation/global/widgets/failed_request.dart';
import 'package:pokedex/app/presentation/modules/home/view/widgets/pokemon_tile.dart';
import 'package:pokedex/app/presentation/modules/home/view/widgets/pokemos_list.dart';
import 'package:pokedex/app/presentation/router/routes.dart';

import '../../../mocks/mocks.mocks.dart';

void main() {
  late MockPokedexRepository repository;
  setUp(
    () {
      repository = MockPokedexRepository();
      GetIt.I.registerLazySingleton<PokedexRepository>(
        () => repository,
      );
      ExtendedImage.globalStateWidgetBuilder = (_, state) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        );
      };
    },
  );

  tearDown(
    GetIt.I.resetScope,
  );

  testWidgets(
    'HomeView > load > success',
    (tester) async {
      when(
        repository.getPokemons(
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer(
        (_) async {
          await Future.delayed(
            const Duration(milliseconds: 50),
          );
          return Either.right(
            List.generate(
              150,
              (index) => Pokemon(
                id: index,
                name: '${index}name',
                url: 'url',
              ),
            ),
          );
        },
      );

      await _initApp(tester);
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
      );

      expect(
        find.byType(PokemonsList),
        findsOneWidget,
      );

      /// test filter
      await tester.enterText(
        find.byType(TextField),
        '140n',
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.byType(PokemonTile),
        findsOneWidget,
      );

      await tester.tap(
        find.byType(PokemonTile),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('pokemon-view'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'HomeView > load > fail',
    (tester) async {
      when(
        repository.getPokemons(
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer(
        (_) async {
          await Future.delayed(
            const Duration(milliseconds: 50),
          );
          return Either.left(
            HttpRequestFailure.network(),
          );
        },
      );

      await _initApp(tester);
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
      );

      expect(
        find.byType(FailedRequest),
        findsOneWidget,
      );

      /// test retry
      await tester.tap(
        find.byType(ElevatedButton),
      );
      await tester.pump();
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
    },
  );
}

Future<void> _initApp(WidgetTester tester) {
  return tester.pumpWidget(
    MyApp(
      overrideRoutes: [
        GoRoute(
          path: '/pokemon/:id',
          name: Routes.pokemon,
          builder: (_, __) => const Scaffold(
            key: Key('pokemon-view'),
          ),
        ),
      ],
    ),
  );
}
