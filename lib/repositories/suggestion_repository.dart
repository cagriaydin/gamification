import 'package:yorglass_ik/models/suggestion.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

class SuggestionRepository {
  sendSuggestion(Suggestion suggestion) async {
    suggestion.id = AuthenticationService.verifiedUser.id;
    suggestion.status = 0;
    suggestion.type = 0;
    suggestion.date = DateTime.now();
    // await sendSuggestion(suggeestion);
  }
}
