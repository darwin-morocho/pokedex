import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_events.freezed.dart';

@freezed
class PokemonEvents with _$PokemonEvents {
  factory PokemonEvents.load() = LoadPokemon;
}
