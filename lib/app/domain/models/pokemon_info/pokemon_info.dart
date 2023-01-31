import 'package:freezed_annotation/freezed_annotation.dart';

import '../../typedefs.dart';

part 'pokemon_info.freezed.dart';
part 'pokemon_info.g.dart';

@freezed
class PokemonInfo with _$PokemonInfo {
  factory PokemonInfo({
    required String name,
    @JsonKey(fromJson: _abilitiesFromJson) required List<Ability> abilities,
    @JsonKey(fromJson: _movesFromJson) required List<Move> moves,
    required List<Stat> stats,
  }) = _PokemonInfo;

  factory PokemonInfo.fromJson(Json json) => _$PokemonInfoFromJson(json);
}

@freezed
class Ability with _$Ability {
  factory Ability({
    required String name,
    required String url,
  }) = _Ability;

  factory Ability.fromJson(Json json) => _$AbilityFromJson(json);
}

@freezed
class Move with _$Move {
  factory Move({
    required String name,
    required String url,
  }) = _Move;

  factory Move.fromJson(Json json) => _$MoveFromJson(json);
}

@freezed
class Stat with _$Stat {
  factory Stat({
    @JsonKey(name: 'stat', fromJson: _statNameFromJson) required String name,
    @JsonKey(name: 'base_stat') required int value,
  }) = _Stat;

  factory Stat.fromJson(Json json) => _$StatFromJson(json);
}

List<Ability> _abilitiesFromJson(List list) => list
    .map(
      (e) => Ability.fromJson(
        e['ability'],
      ),
    )
    .toList();

List<Move> _movesFromJson(List list) => list
    .map(
      (e) => Move.fromJson(
        e['move'],
      ),
    )
    .toList();

String _statNameFromJson(Map map) => map['name'];
