import 'package:flutter/material.dart';

class PokemonView extends StatelessWidget {
  const PokemonView({
    super.key,
    required this.id,
    required this.imageUrlPreview,
  });
  final String id;
  final String? imageUrlPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
