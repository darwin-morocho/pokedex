import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../domain/models/pokemon_info/pokemon_info.dart';

part 'pokemon_state.freezed.dart';

@freezed
class PokemonState with _$PokemonState {
  factory PokemonState.loading() = _Loading;
  factory PokemonState.loaded(PokemonInfo info) = _Loaded;
  factory PokemonState.failed(HttpRequestFailure failure) = _Failed;
}
