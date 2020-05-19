import 'package:mysql1/mysql1.dart';
import 'package:uuid/uuid.dart';
import 'package:yorglass_ik/models/suggestion.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class SuggestionRepository {
  static final SuggestionRepository _instance =
      SuggestionRepository._privateConstructor();

  SuggestionRepository._privateConstructor();

  static SuggestionRepository get instance => _instance;

  Future<bool> hasSuggestionLimit() async {
    Results res = await DbConnection.query(
        "SELECT * FROM suggestion where uid = (?) and YEAR(date) = (?) and MONTH(date) = (?) and DAY(date) = (?)",
        [
          AuthenticationService.verifiedUser.id,
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day
        ]);
    if (res.length == 10) {
      return false;
    }
    return true;
  }

  sendSuggestion(Suggestion suggestion) async {
    suggestion.id = Uuid().v4();
    suggestion.uid = AuthenticationService.verifiedUser.id;
    suggestion.status = 0;
    suggestion.type = 0;
    suggestion.date = DateTime.now();
    suggestion.flag = "";

    await DbConnection.query(
      'INSERT INTO suggestion (id, uid, title, description, type, status, flag, date) VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
      [
        suggestion.id,
        suggestion.uid,
        suggestion.title,
        suggestion.description,
        suggestion.type,
        suggestion.status,
        suggestion.flag,
        suggestion.date.toUtc(),
      ],
    );
  }
}
