import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/app/domain/either/either.dart';
import 'package:pokedex/app/domain/failures/http_request/http_request_failure.dart';
import 'package:pokedex/app/domain/models/pokemon_info/pokemon_info.dart';
import 'package:pokedex/app/domain/repositories/pokedex_repository.dart';
import 'package:pokedex/app/my_app.dart';
import 'package:pokedex/app/presentation/global/widgets/failed_request.dart';

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
    'PokemonView > load > success',
    (tester) async {
      final abilities = <Ability>[
        Ability(name: 'eat', url: 'url'),
        Ability(name: 'run', url: 'url'),
      ];
      final moves = <Move>[
        Move(name: 'push', url: 'url'),
        Move(name: 'pull', url: 'url'),
      ];

      when(
        repository.getPokemon(any),
      ).thenAnswer(
        (_) async {
          await Future.delayed(
            const Duration(milliseconds: 50),
          );
          return Either.right(
            PokemonInfo(
              name: 'pikachu',
              abilities: abilities,
              moves: moves,
              stats: [],
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
        find.text('- ${abilities.first.name}'),
        findsOneWidget,
      );
      expect(
        find.text('- ${moves.first.name}'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'PokemonView > load > fail',
    (tester) async {
      when(
        repository.getPokemon(any),
      ).thenAnswer(
        (_) async {
          await Future.delayed(
            const Duration(milliseconds: 50),
          );
          return Either.left(
            HttpRequestFailure.notFound(),
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
    const MyApp(
      initialRoute: '/pokemon/123',
    ),
  );
}
