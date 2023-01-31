import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../domain/models/pokemon/pokemon.dart';
import '../../../../router/routes.dart';
import '../../../../utils/get_image_url.dart';

class PokemonTile extends StatelessWidget {
  const PokemonTile({super.key, required this.pokemon});
  final Pokemon pokemon;

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
                  'id': pokemon.id.toString(),
                },
              );
            },
            child: ExtendedImage.network(
              getImageUrl(
                pokemon.id.toString(),
              ),
            ),
          ),
        ),
        Text(pokemon.name),
      ],
    );
  }
}
