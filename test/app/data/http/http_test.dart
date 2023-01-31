import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/app/data/http/http.dart';
import 'package:pokedex/app/data/http/result.dart';

@GenerateMocks(
  [Client],
)
import 'http_test.mocks.dart';

void main() {
  late MockClient client;
  late Http http;

  setUp(
    () {
      client = MockClient();
      http = Http(
        baseUrl: 'https://pokeapi.co',
        client: client,
      );
    },
  );

  test(
    'Http > success',
    () async {
      when(
        client.send(any),
      ).thenAnswer(
        (invocation) async {
          final request = invocation.positionalArguments.first as Request;
          expect(
            request.url.toString(),
            'https://pokeapi.co/api/v2/pokemon?offset=0&limit=150',
          );
          expect(
            request.method,
            'GET',
          );
          return StreamedResponse(
            Stream.value(
              utf8.encode(
                jsonEncode(
                  {
                    'results': [],
                  },
                ),
              ),
            ),
            200,
          );
        },
      );

      final result = await http.request(
        'api/v2/pokemon',
        queryParameters: {
          'offset': '0',
          'limit': '150',
        },
        parser: (_, json) {
          return json['results'] as List;
        },
      );
      expect(
        result,
        isA<HttpSuccess>(),
      );
    },
  );

  test(
    'Http > fail',
    () async {
      when(
        client.send(any),
      ).thenThrow(
        const SocketException('fake error'),
      );

      final result = await http.request(
        'api/v2/pokemon',
      );
      expect(
        result,
        isA<HttpFailure>(),
      );
    },
  );

  test(
    'Http > Server error',
    () async {
      when(
        client.send(any),
      ).thenAnswer(
        (_) async => StreamedResponse(
          Stream.value(
            utf8.encode(
              jsonEncode({'message': 'bad request'}),
            ),
          ),
          400,
        ),
      );

      final result = await http.request(
        'api/v2/pokemon',
      );
      expect(
        result,
        isA<HttpFailure>(),
      );
    },
  );

  test(
    'Http > POST',
    () async {
      const url = 'https://fake.com/api/v2/pokemon';
      when(
        client.send(any),
      ).thenAnswer(
        (invocation) async {
          final request = invocation.positionalArguments.first as Request;

          expect(
            request.url.toString(),
            '$url?',
          );

          expect(request.method, 'POST');
          expect(jsonDecode(request.body)['id'], 123);

          return StreamedResponse(
            Stream.value(utf8.encode('')),
            201,
          );
        },
      );

      final result = await http.request(
        url,
        method: 'POST',
        body: {
          'id': 123,
        },
      );

      expect(
        result,
        isA<HttpSuccess>(),
      );
    },
  );
}
