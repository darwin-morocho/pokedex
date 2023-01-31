import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../domain/models/pokemon/pokemon.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState.loading() = _Loading;
  factory HomeState.loaded(List<Pokemon> pokemons) = _Loaded;
  factory HomeState.failed(HttpRequestFailure failure) = _Failed;
}
