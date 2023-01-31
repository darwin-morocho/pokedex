import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/app/data/http/http.dart';
import 'package:pokedex/app/data/repositories_impl/pokedex_repository_impl.dart';
import 'package:pokedex/app/data/services/remote/pokedex_api.dart';
import 'package:pokedex/app/domain/failures/http_request/http_request_failure.dart';
import 'package:pokedex/app/domain/models/pokemon/pokemon.dart';
import 'package:pokedex/app/domain/models/pokemon_info/pokemon_info.dart';
import 'package:pokedex/app/domain/repositories/pokedex_repository.dart';

import '../../../mocks/mocks.mocks.dart';

void main() {
  late MockClient client;
  late PokedexRepository repository;

  setUp(
    () {
      client = MockClient();
      repository = PokedexRepositoryImpl(
        PokedexAPI(
          Http(
            baseUrl: 'https://pokeapi.co',
            client: client,
          ),
        ),
      );
    },
  );

  group(
    'PokedexRepositoryImpl > ',
    () {
      test(
        'getPokemons > success',
        () async {
          when(
            client.send(any),
          ).thenAnswer(
            (_) async => StreamedResponse(
              Stream.value(
                utf8.encode(
                  jsonEncode(
                    {
                      'count': 1279,
                      'next': null,
                      'previous': null,
                      'results': [
                        {
                          'name': 'ivysaur',
                          'url': 'https://pokeapi.co/api/v2/pokemon/2/'
                        },
                      ],
                    },
                  ),
                ),
              ),
              200,
            ),
          );
          final result = await repository.getPokemons(
            offset: 0,
            limit: 100,
          );

          expect(
            result.when(
              left: (failure) => failure,
              right: (list) => list,
            ),
            isA<List<Pokemon>>(),
          );
        },
      );

      test(
        'getPokemons > failure',
        () async {
          when(
            client.send(any),
          ).thenAnswer(
            (_) async => StreamedResponse(
              Stream.value(
                utf8.encode(
                  jsonEncode(
                    {},
                  ),
                ),
              ),
              500,
            ),
          );
          final result = await repository.getPokemons(
            offset: 0,
            limit: 100,
          );

          expect(
            result.when(
              left: (failure) => failure,
              right: (list) => list,
            ),
            isA<HttpRequestFailure>(),
          );
        },
      );

      test(
        'getPokemon > success',
        () async {
          when(
            client.send(any),
          ).thenAnswer(
            (_) async => StreamedResponse(
              Stream.value(
                utf8.encode(
                  jsonEncode(
                    {
                      'name': 'ivysaur',
                      'abilities': [
                        {
                          'ability': {
                            'name': 'overgrow',
                            'url': 'https://pokeapi.co/api/v2/ability/65/'
                          },
                        },
                      ],
                      'moves': [
                        {
                          'move': {
                            'name': 'swords-dance',
                            'url': 'https://pokeapi.co/api/v2/move/14/'
                          },
                        },
                      ],
                      'stats': [
                        {
                          'base_stat': 63,
                          'stat': {
                            'name': 'defense',
                            'url': 'https://pokeapi.co/api/v2/stat/3/'
                          }
                        },
                      ],
                    },
                  ),
                ),
              ),
              200,
            ),
          );
          final result = await repository.getPokemon('123');

          expect(
            result.when(
              left: (failure) => failure,
              right: (info) => info,
            ),
            isA<PokemonInfo>(),
          );
        },
      );

      test(
        'getPokemon > failure > network',
        () async {
          when(
            client.send(any),
          ).thenThrow(
            const SocketException(''),
          );
          final result = await repository.getPokemon('123');

          expect(
            result.when(
              left: (failure) => failure,
              right: (list) => list,
            ),
            isA<HttpRequestFailure>(),
          );
        },
      );

      test(
        'getPokemon > failure > not found',
        () async {
          when(
            client.send(any),
          ).thenAnswer(
            (_) async => StreamedResponse(
              Stream.value(
                utf8.encode(
                  jsonEncode(
                    {},
                  ),
                ),
              ),
              404,
            ),
          );
          final result = await repository.getPokemon('123');

          expect(
            result.when(
              left: (failure) => failure,
              right: (list) => list,
            ),
            isA<HttpRequestFailure>(),
          );
        },
      );

      test(
        'getPokemon > failure > unhandled',
        () async {
          when(
            client.send(any),
          ).thenAnswer(
            (_) async => StreamedResponse(
              Stream.value(
                utf8.encode(
                  jsonEncode(
                    {},
                  ),
                ),
              ),
              200,
            ),
          );
          final result = await repository.getPokemon('123');

          expect(
            result.when(
              left: (failure) => failure,
              right: (list) => list,
            ),
            isA<HttpRequestFailure>(),
          );
        },
      );
    },
  );
}
