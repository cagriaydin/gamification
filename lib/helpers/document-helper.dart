import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class DocumentHelper {
  Future<String> getPhoneWithRegNumber(String regNumber) async {
    if(regNumber == ""){
      return "";
    }
    Results res = await DbConnection.query("SELECT phone FROM user WHERE code = ?", [int.parse(regNumber)]);
    if (res.toList().length > 0) {
      String phone = res.toList().first[0];
      return phone;
    }
    // ByteData data = await rootBundle.load("documents/yorglass.xlsx");
    // var decoder = Excel.decodeBytes(
    //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    // var table = decoder.tables.keys.first;
    // for (var row in decoder.tables[table].rows) {
    //   if (row[1] == int.tryParse(regNumber)) {
    //     return row[3].toString();
    //   }
    // }
    //return "5415435019";
  }
}
