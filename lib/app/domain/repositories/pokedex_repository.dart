import '../either/either.dart';
import '../failures/http_request/http_request_failure.dart';
import '../models/pokemon/pokemon.dart';
import '../models/pokemon_info/pokemon_info.dart';

abstract class PokedexRepository {
  Future<Either<HttpRequestFailure, List<Pokemon>>> getPokemons({
    required int offset,
    required int limit,
  });

  Future<Either<HttpRequestFailure, PokemonInfo>> getPokemon(String id);
}
