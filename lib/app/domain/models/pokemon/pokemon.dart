import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon.freezed.dart';

@freezed
class Pokemon with _$Pokemon {
  factory Pokemon({
    required int id,
    required String name,
    required String url,
  }) = _Pokemon;
}
