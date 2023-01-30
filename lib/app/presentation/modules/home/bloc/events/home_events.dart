import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_events.freezed.dart';

@freezed
class HomeEvents with _$HomeEvents {
  factory HomeEvents.load({
    required int offset,
    required int limit,
  }) = LoadPokemons;
}
