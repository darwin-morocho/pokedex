import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/app/domain/either/either.dart';
import 'package:pokedex/app/domain/failures/http_request/http_request_failure.dart';
import 'package:pokedex/app/presentation/modules/home/bloc/events/home_events.dart';
import 'package:pokedex/app/presentation/modules/home/bloc/home_bloc.dart';
import 'package:pokedex/app/presentation/modules/home/bloc/state/home_state.dart';

import '../../../mocks/mocks.mocks.dart';

void main() {
  late HomeBloc bloc;
  late MockPokedexRepository repository;

  setUp(
    () {
      repository = MockPokedexRepository();
      bloc = HomeBloc(
        HomeState.loading(),
        pokedexRepository: repository,
      );
    },
  );

  test(
    'HomeBloc > load > success',
    () async {
      when(
        repository.getPokemons(
          offset: 0,
          limit: 100,
        ),
      ).thenAnswer(
        (_) async => Either.right(
          [],
        ),
      );

      /// HERE I DO NOT USE bloc_test due to
      /// it is not compatible with the lastest
      /// version of freezed and analizer
      ///
      bloc.add(
        HomeEvents.load(offset: 0, limit: 100),
      );

      await Future.delayed(Duration.zero);

      expect(
        bloc.state.maybeWhen(
          loaded: (_) => true,
          orElse: () => false,
        ),
        true,
      );
    },
  );

  test(
    'HomeBloc > load > failed',
    () async {
      when(
        repository.getPokemons(
          offset: 0,
          limit: 100,
        ),
      ).thenAnswer(
        (_) async => Either.left(
          HttpRequestFailure.network(),
        ),
      );

      /// HERE I DO NOT USE bloc_test due to
      /// it is not compatible with the lastest
      /// version of freezed and analizer
      ///
      bloc.add(
        HomeEvents.load(offset: 0, limit: 100),
      );

      await Future.delayed(Duration.zero);

      expect(
        bloc.state.maybeWhen(
          failed: (_) => true,
          orElse: () => false,
        ),
        true,
      );

      bloc.add(
        HomeEvents.load(offset: 0, limit: 100),
      );
      await Future.delayed(Duration.zero);
      expect(
        bloc.state.maybeWhen(
          failed: (_) => true,
          orElse: () => false,
        ),
        true,
      );
    },
  );
}
