import '../../../domain/models/pokemon/pokemon.dart';
import '../../../domain/models/pokemon_info/pokemon_info.dart';
import '../../http/http.dart';
import '../../http/result.dart';

class PokedexAPI {
  final Http _http;

  PokedexAPI(this._http);

  Future<HttpResult<List<Pokemon>>> getPokemons({
    required int offset,
    required int limit,
  }) {
    return _http.request(
      '/api/v2/pokemon',
      queryParameters: {
        'offset': offset.toString(),
        'limit': limit.toString(),
      },
      parser: (_, json) {
        return (json['results'] as List).map(
          (e) {
            final url = e['url'] as String;
            final pathSegments = Uri.parse(url).pathSegments;

            final name = e['name'] as String;

            /// extract the id from url
            /// example  https://pokeapi.co/api/v2/pokemon/1/ => id: 1
            final id = int.parse(
              pathSegments[pathSegments.length - 2],
            );
            return Pokemon(id: id, name: name, url: url);
          },
        ).toList();
      },
    );
  }

  Future<HttpResult<PokemonInfo>> getPokemonInfo(String id) {
    return _http.request(
      '/api/v2/pokemon/$id',
      parser: (_, json) => PokemonInfo.fromJson(json),
    );
  }
}
