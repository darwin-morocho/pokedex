import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../generated/assets.gen.dart';
import '../bloc/events/home_events.dart';
import '../bloc/home_bloc.dart';
import '../bloc/state/home_state.dart';
import 'widgets/failed_request.dart';
import 'widgets/pokemos_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final loadEvent = HomeEvents.load(
      offset: 0,
      limit: 150,
    );

    return BlocProvider(
      create: (_) => HomeBloc(
        HomeState.loading(),
        pokedexRepository: GetIt.I.get(),
      )..add(loadEvent),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Assets.images.pokedex.image(
            width: 120,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: Builder(
          builder: (context) {
            final HomeBloc bloc = context.watch();
            return bloc.state.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              loaded: (pokemons) => PokemonsList(pokemons: pokemons),
              failed: (failure) => FailedRequest(
                onRetry: () => bloc.add(loadEvent),
                failure: failure,
              ),
            );
          },
        ),
      ),
    );
  }
}
