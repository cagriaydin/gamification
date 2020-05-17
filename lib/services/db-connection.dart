import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

class DbConnection {
  static Future<Results> query(String sql, [List<Object> values]) async {
    ConnectionSettings settings;
    if (AuthenticationService.verifiedUser != null) {
      settings = new ConnectionSettings(
        host: '178.18.207.118',
        port: 3306,
        user: 'yorglass_verify',
        password: '#WAijrX1=!5*',
        db: 'yorglass_ik',
      );
    } else {
      settings = new ConnectionSettings(
        host: '178.18.207.118',
        port: 3306,
        user: 'yorglass_read',
        password: '?KWOrrIM0k7g',
        db: 'yorglass_ik',
      );
    }
    MySqlConnection conn = await MySqlConnection.connect(settings);
    return await conn.query(sql, values);
  }
}
