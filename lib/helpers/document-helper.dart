import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class DocumentHelper {
  Future<String> getPhoneWithRegNumber(String regNumber) async {
    // ByteData data = await rootBundle.load("documents/yorglass.xlsx");
    // var decoder = Excel.decodeBytes(
    //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    // var table = decoder.tables.keys.first;
    // for (var row in decoder.tables[table].rows) {
    //   if (row[1] == int.tryParse(regNumber)) {
    //     return row[3].toString();
    //   }
    // }
    // return "";
    return regNumber;
  }
}
