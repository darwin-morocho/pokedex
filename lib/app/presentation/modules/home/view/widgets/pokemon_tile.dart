import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../domain/tuple.dart';
import '../../../../router/routes.dart';
import '../../../../utils/get_image_url.dart';

class PokemonTile extends StatelessWidget {
  const PokemonTile({super.key, required this.pokemon});
  final Tuple<int, String> pokemon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              context.pushNamed(
                Routes.pokemon,
                params: {
                  'id': pokemon.item1.toString(),
                },
                extra: pokemon.item2,
              );
            },
            child: ExtendedImage.network(
              getImageUrl(
                pokemon.item1.toString(),
              ),
              loadStateChanged: (state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case LoadState.completed:
                    return state.completedWidget;
                  case LoadState.failed:
                    return Text(
                      state.lastException.toString(),
                    );
                }
              },
            ),
          ),
        ),
        Text(pokemon.item2),
      ],
    );
  }
}
