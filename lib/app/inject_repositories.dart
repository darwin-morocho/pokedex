import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import 'data/http/http.dart';
import 'data/repositories_impl/pokedex_repository_impl.dart';
import 'data/services/remote/pokedex_api.dart';
import 'domain/repositories/pokedex_repository.dart';

void injectRepositories({
  required String baseUrl,
  required Client client,
}) {
  final http = Http(
    baseUrl: baseUrl,
    client: client,
  );

  GetIt.I.registerLazySingleton<PokedexRepository>(
    () => PokedexRepositoryImpl(
      PokedexAPI(http),
    ),
  );
}
