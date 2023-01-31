import 'package:flutter/material.dart';

import '../../../../../domain/models/pokemon_info/pokemon_info.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails({
    super.key,
    required this.info,
  });
  final PokemonInfo info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                info.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Abilities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...info.abilities.map(
              (e) => Text('- ${e.name}'),
            ),
            const SizedBox(height: 15),
            const Text(
              'Moves',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...info.moves.map(
              (e) => Text('- ${e.name}'),
            ),
          ],
        ),
      ),
    );
  }
}
