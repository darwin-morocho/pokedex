import '../../domain/either/either.dart';
import '../../domain/failures/http_request/http_request_failure.dart';
import '../../domain/models/pokemon/pokemon.dart';
import '../../domain/models/pokemon_info/pokemon_info.dart';
import '../../domain/repositories/pokedex_repository.dart';
import '../services/remote/pokedex_api.dart';
import '../utils/perform_http_request.dart';

class PokedexRepositoryImpl implements PokedexRepository {
  final PokedexAPI _api;

  PokedexRepositoryImpl(this._api);

  @override
  Future<Either<HttpRequestFailure, PokemonInfo>> getPokemon(String id) {
    return performHttpRequest(
      _api.getPokemonInfo(id),
    );
  }

  @override
  Future<Either<HttpRequestFailure, List<Pokemon>>> getPokemons({
    required int offset,
    required int limit,
  }) {
    return performHttpRequest(
      _api.getPokemons(
        offset: offset,
        limit: limit,
      ),
    );
  }
}
