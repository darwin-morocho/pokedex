import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../domain/models/pokemon/pokemon.dart';
import 'pokemon_tile.dart';

class PokemonsList extends HookWidget {
  const PokemonsList({super.key, required this.pokemons});
  final List<Pokemon> pokemons;

  @override
  Widget build(BuildContext context) {
    final query = useValueNotifier('');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: TextField(
            onChanged: (text) {
              text = text.trim().toLowerCase();
              query.value = text;
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              hintText: 'Search...',
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: query,
            builder: (_, query, __) {
              final filteredList = query.isEmpty
                  ? pokemons
                  : pokemons
                      .where(
                        (e) => e.name.toLowerCase().contains(
                              query,
                            ),
                      )
                      .toList();

              return GridView.builder(
                itemBuilder: (_, index) => PokemonTile(
                  pokemon: filteredList[index],
                ),
                itemCount: filteredList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
              );
            },
          ),
        ),
      ],
    );
  }
}
