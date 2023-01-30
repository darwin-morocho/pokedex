import '../../core/env.dart';

String getImageUrl(String pokemonId) {
  final path = pokemonId.padLeft(3, '0');
  return '${Env.baseImageUrl}$path.png';
}
