import 'package:flutter/material.dart';

import '../../../../../domain/tuple.dart';
import 'pokemon_tile.dart';

class PokemonsList extends StatefulWidget {
  const PokemonsList({super.key, required this.pokemons});
  final List<Tuple<int, String>> pokemons;

  @override
  State<PokemonsList> createState() => _PokemonsListState();
}

class _PokemonsListState extends State<PokemonsList> {
  final _query = ValueNotifier('');

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: TextField(
            onChanged: (text) {
              text = text.trim().toLowerCase();
              _query.value = text;
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
            valueListenable: _query,
            builder: (_, query, __) {
              final filteredList = query.isEmpty
                  ? widget.pokemons
                  : widget.pokemons
                      .where(
                        (e) => e.item2.toLowerCase().contains(
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
