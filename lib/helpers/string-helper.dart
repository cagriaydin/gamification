import 'package:yorglass_ik/helpers/document-helper.dart';

class StringHelper {
  static bool isValidPhoneNumber(String phonenumber) {
    return phonenumber.isNotEmpty &&
        phonenumber.length == 11 &&
        phonenumber.startsWith("05");
  }

  static Future<String> getPhoneWithRegNumber(String regNumber) async {
    return await DocumentHelper().getPhoneWithRegNumber(regNumber);
  }
}
