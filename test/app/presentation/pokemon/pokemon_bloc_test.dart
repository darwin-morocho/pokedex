import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/app/domain/either/either.dart';
import 'package:pokedex/app/domain/failures/http_request/http_request_failure.dart';
import 'package:pokedex/app/domain/models/pokemon_info/pokemon_info.dart';
import 'package:pokedex/app/presentation/modules/pokemon/bloc/events/pokemon_events.dart';
import 'package:pokedex/app/presentation/modules/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/app/presentation/modules/pokemon/bloc/state/pokemon_state.dart';

import '../../../mocks/mocks.mocks.dart';

void main() {
  late PokemonBloc bloc;
  late MockPokedexRepository repository;

  setUp(
    () {
      repository = MockPokedexRepository();
      bloc = PokemonBloc(
        PokemonState.loading(),
        pokedexRepository: repository,
        pokemonId: '123',
      );
    },
  );

  test(
    'PokemonBloc > load success',
    () async {
      when(
        repository.getPokemon(any),
      ).thenAnswer(
        (_) async => Either.right(
          PokemonInfo(
            abilities: [],
            moves: [],
            name: '',
            stats: [],
          ),
        ),
      );

      /// HERE I DO NOT USE bloc_test due to
      /// it is not compatible with the lastest
      /// version of freezed and analizer
      ///

      bloc.add(
        PokemonEvents.load(),
      );

      await Future.delayed(Duration.zero);

      expect(
        bloc.state.maybeWhen(
          loaded: (_) => true,
          orElse: () => false,
        ),
        true,
      );
    },
  );

  test(
    'PokemonBloc > load failed',
    () async {
      when(
        repository.getPokemon(any),
      ).thenAnswer(
        (_) async => Either.left(
          HttpRequestFailure.server(),
        ),
      );

      bloc.add(
        PokemonEvents.load(),
      );

      await Future.delayed(Duration.zero);

      expect(
        bloc.state.maybeWhen(
          failed: (_) => true,
          orElse: () => false,
        ),
        true,
      );

      bloc.add(
        PokemonEvents.load(),
      );
      await Future.delayed(Duration.zero);
      expect(
        bloc.state.maybeWhen(
          failed: (_) => true,
          orElse: () => false,
        ),
        true,
      );
    },
  );
}
