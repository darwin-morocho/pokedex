import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/app/domain/repositories/pokedex_repository.dart';
import 'package:pokedex/app/inject_repositories.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  test(
    'injectRepositories',
    () {
      expect(
        () => GetIt.I.get<PokedexRepository>(),
        throwsAssertionError,
      );

      injectRepositories(
        baseUrl: 'baseUrl',
        client: MockClient(),
      );

      expect(
        GetIt.I.get<PokedexRepository>(),
        isA<PokedexRepository>(),
      );
    },
  );
}
