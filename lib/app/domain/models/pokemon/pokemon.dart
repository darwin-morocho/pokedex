import 'package:freezed_annotation/freezed_annotation.dart';

import '../../typedefs.dart';

part 'pokemon.freezed.dart';
part 'pokemon.g.dart';

@freezed
class Pokemon with _$Pokemon {
  factory Pokemon() = _Pokemon;

  factory Pokemon.fromJson(Json json) => _$PokemonFromJson(json);
}
