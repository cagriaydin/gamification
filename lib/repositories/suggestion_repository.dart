import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:yorglass_ik/models/suggestion.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

class SuggestionRepository {
  static final SuggestionRepository _instance =
      SuggestionRepository._privateConstructor();

  SuggestionRepository._privateConstructor();

  static SuggestionRepository get instance => _instance;

  Future<bool> hasSuggestionLimit() async {
    Response suggestionLimitRes =
        await RestApi.instance.dio.get('/suggestion/hasSuggestionLimit');
    return suggestionLimitRes.data ?? false;
  }

  Future<bool> sendSuggestion(Suggestion suggestion) async {
    suggestion.id = Uuid().v4();
    suggestion.uid = AuthenticationService.verifiedUser.id;
    suggestion.status = 0;
    suggestion.type = 0;
    suggestion.date = DateTime.now();
    suggestion.flag = "";

    Response response = await RestApi.instance.dio
        .post('/suggestion/addSuggestion', data: suggestion.toJson());

    if (response != null &&
        response.data != null &&
        response.statusCode == 200) {
      await TaskRepository.instance.updateLeaderboardPoint(10);
      return true;
    }
    else{
      return false;
    }
  }
}
