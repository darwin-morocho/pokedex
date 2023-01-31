import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:pokedex/app/domain/repositories/pokedex_repository.dart';

@GenerateMocks(
  [Client, PokedexRepository],
)
// ignore: unused_import
import 'mocks.mocks.dart';
