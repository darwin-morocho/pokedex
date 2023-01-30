import 'package:bloc/bloc.dart';

import '../../../../domain/repositories/pokedex_repository.dart';
import 'events/home_events.dart';
import 'state/home_state.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeBloc(
    super.initialState, {
    required PokedexRepository pokedexRepository,
  }) : _pokedexRepository = pokedexRepository {
    _init();
  }

  final PokedexRepository _pokedexRepository;

  void _init() {
    on<LoadPokemons>(_onLoadPokemons);
  }

  Future<void> _onLoadPokemons(
    LoadPokemons event,
    Emitter<HomeState> emit,
  ) async {
    final loading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    if (!loading) {
      emit(
        HomeState.loading(),
      );
    }

    final result = await _pokedexRepository.getPokemons(
      offset: event.offset,
      limit: event.limit,
    );

    emit(
      result.when(
        left: (failure) => HomeState.failed(failure),
        right: (pokemons) => HomeState.loaded(pokemons),
      ),
    );
  }
}
