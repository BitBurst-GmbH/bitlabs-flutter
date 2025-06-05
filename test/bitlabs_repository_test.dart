import 'package:bitlabs/src/api/bitlabs/bitlabs_service.dart';
import 'package:bitlabs/src/api/bitlabs/bitlabs_repository.dart';
import 'package:bitlabs/src/models/bitlabs/get_leaderboard_response.dart';
import 'package:bitlabs/src/models/bitlabs/survey.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'bitlabs_repository_test.mocks.dart';

@GenerateMocks([BitLabsService])
void main() {
  errorBody() => """
    {"error": {
      "details": {
        "http": "400",
        "msg": "string"
      }
    },
    "status": "error",
    "trace_id": "1dc6786b10a62ec6"}
  """;

  dataBody(String data) => """
    {"data": $data,
    "status": "success",
    "trace_id": "1dc6786b10a62ec6"}
  """;

  group('getSurveys', () {
    test('Failure', () {
      final api = MockBitLabsService();
      when(api.getSurveys()).thenAnswer((_) async => Response('', 400));

      final repository = BitLabsRepository(api);
      repository.getSurveys(
        (_) => fail('Should not be called'),
        (e) => expect(e, isA<Exception>()),
      );
    });

    test('Success', () {
      final api = MockBitLabsService();
      when(api.getSurveys()).thenAnswer((_) async => Response(dataBody("""
          {
          "surveys": [
            {
              "id": "string",
              "type": "survey",
              "click_url": "string",
              "cpi": "1.2",
              "value": "120",
              "loi": 5.3,
              "country": "US",
              "language": "en",
              "rating": 4,
              "category": {
                "name": "Automotive",
                "icon_name": "string",
                "icon_url": "string",
                "name_internal": "automotive"
              },
              "tags": [
                "pii"
              ]
            }
          ]}
          """), 200));

      final repository = BitLabsRepository(api);
      repository.getSurveys(
        (surveys) => expect(surveys, isA<List<Survey>>()),
        (_) => fail('Should not be called'),
      );
    });

    test('Error', () {
      final api = MockBitLabsService();
      when(api.getSurveys())
          .thenAnswer((_) async => Response(errorBody(), 400));

      final repository = BitLabsRepository(api);
      repository.getSurveys(
        (_) => fail('Should not be called'),
        (e) => expect(e, isA<Exception>()),
      );
    });
  });

  group('getLeaderboard', () {
    test('Failure', () {
      final api = MockBitLabsService();
      when(api.getLeaderboard()).thenAnswer((_) async => Response('', 400));

      final repository = BitLabsRepository(api);
      repository.getLeaderboard(
        (_) => fail('Should not be called'),
        (error) => expect(error, isA<Exception>()),
      );
    });

    test('Success', () {
      final api = MockBitLabsService();
      when(api.getLeaderboard()).thenAnswer((_) async => Response(dataBody("""
      {
        "next_reset_at": "2021-09-30T00:00:00Z",
        "own_user": {
          "rank": 1,
          "name": "string",
          "earnings_raw": 0
        },
        "rewards": [
          {
            "rank": 1,
            "reward_raw": 0
          }
        ]
      }
      """), 200));

      final repository = BitLabsRepository(api);
      repository.getLeaderboard(
        (leaderboard) => expect(leaderboard, isA<GetLeaderboardResponse>()),
        (_) => fail('Should not be called'),
      );
    });

    test('Error', () {
      final api = MockBitLabsService();
      when(api.getLeaderboard())
          .thenAnswer((_) async => Response(errorBody(), 400));

      final repository = BitLabsRepository(api);
      repository.getLeaderboard(
        (_) => fail('Should not be called'),
        (error) => expect(error, isA<Exception>()),
      );
    });
  });

  group('leaveSurvey', () {
    test('Failure', () {
      final api = MockBitLabsService();
      when(api.updateClick('', '')).thenAnswer((_) async => Response('', 400));

      final repository = BitLabsRepository(api);
      repository.leaveSurvey(
        '',
        '',
        (_) => fail('Should not be called'),
        (error) => expect(error, isA<Exception>()),
      );
    });

    test('Success', () {
      final api = MockBitLabsService();
      when(api.updateClick('', ''))
          .thenAnswer((_) async => Response(dataBody("{}"), 200));

      final repository = BitLabsRepository(api);
      repository.leaveSurvey(
        '',
        '',
        (response) => expect(response, isA<String>()),
        (_) => fail('Should not be called'),
      );
    });

    test('Error', () {
      final api = MockBitLabsService();
      when(api.updateClick('', ''))
          .thenAnswer((_) async => Response(errorBody(), 400));

      final repository = BitLabsRepository(api);
      repository.leaveSurvey(
        '',
        '',
        (_) => fail('Should not be called'),
        (error) => expect(error, isA<Exception>()),
      );
    });
  });

  group('getAppSettings', () {
    test('Failure', () {
      final api = MockBitLabsService();
      when(api.getAppSettings("")).thenAnswer((_) async => Response('', 400));

      final repository = BitLabsRepository(api);
      repository.getAppSettings(
        "",
        (_) => fail('Should not be called'),
        (e) => expect(e, isA<Exception>()),
      );
    });

    test('Success', () {
      final api = MockBitLabsService();
      when(api.getAppSettings("")).thenAnswer((_) async => Response(dataBody("""
      {
        "visual": {
          "survey_icon_color": "linear-gradient(90deg, #FF0000 0%, #00FF00 100%)",
          "navigation_color": "#FF0000"
        },
        "currency": {
          "name": "string",
          "symbol": "string",
          "icon_url": "string"
        },
      }
      """), 200));
    });

    test('Error', () {
      final api = MockBitLabsService();
      when(api.getAppSettings(""))
          .thenAnswer((_) async => Response(errorBody(), 400));

      final repository = BitLabsRepository(api);
      repository.getAppSettings(
        "",
        (_) => fail('Should not be called'),
        (e) => expect(e, isA<Exception>()),
      );
    });
  });
}
