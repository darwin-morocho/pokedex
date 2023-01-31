import 'package:bloc/bloc.dart';

import '../../../../domain/repositories/pokedex_repository.dart';
import 'events/pokemon_events.dart';
import 'state/pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvents, PokemonState> {
  PokemonBloc(
    super.initialState, {
    required this.pokemonId,
    required PokedexRepository pokedexRepository,
  }) : _pokedexRepository = pokedexRepository {
    _init();
  }

  final PokedexRepository _pokedexRepository;
  final String pokemonId;

  void _init() async {
    on<LoadPokemon>(_onLoadPokemon);
  }

  Future<void> _onLoadPokemon(
    LoadPokemon _,
    Emitter<PokemonState> emit,
  ) async {
    final loading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (!loading) {
      emit(
        PokemonState.loading(),
      );
    }

    final result = await _pokedexRepository.getPokemon(
      pokemonId,
    );

    emit(
      result.when(
        left: (failure) => PokemonState.failed(failure),
        right: (info) => PokemonState.loaded(info),
      ),
    );
  }
}
