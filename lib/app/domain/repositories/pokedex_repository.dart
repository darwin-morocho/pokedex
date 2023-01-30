import '../either/either.dart';
import '../failures/http_request/http_request_failure.dart';
import '../models/pokemon/pokemon.dart';
import '../tuple.dart';

abstract class PokedexRepository {
  Future<Either<HttpRequestFailure, List<Tuple<int, String>>>> getPokemons({
    required int offset,
    required int limit,
  });

  Future<Either<HttpRequestFailure, Pokemon>> getPokemon(int id);
}
