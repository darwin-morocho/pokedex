import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../global/widgets/failed_request.dart';
import '../../../utils/get_image_url.dart';
import '../bloc/events/pokemon_events.dart';
import '../bloc/pokemon_bloc.dart';
import '../bloc/state/pokemon_state.dart';
import 'widgets/pokemon_details.dart';

class PokemonView extends StatelessWidget {
  const PokemonView({
    super.key,
    required this.id,
  });
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PokemonBloc(
        PokemonState.loading(),
        pokemonId: id,
        pokedexRepository: GetIt.I.get(),
      )..add(
          PokemonEvents.load(),
        ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: ExtendedImage.network(
                getImageUrl(id),
                height: 250,
              ),
            ),
            Builder(
              builder: (context) {
                final PokemonBloc bloc = context.watch();
                return bloc.state.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  loaded: (info) => SliverToBoxAdapter(
                    child: PokemonDetails(info: info),
                  ),
                  failed: (failure) => SliverFillRemaining(
                    child: FailedRequest(
                      failure: failure,
                      onRetry: () => bloc.add(
                        PokemonEvents.load(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
