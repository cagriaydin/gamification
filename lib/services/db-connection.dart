import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

class DbConnection {
  static MySqlConnection _connection;
  static int _lastConn;
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
      if (_connection == null) {
        _connection = await MySqlConnection.connect(settings);
        _lastConn = DateTime.now().millisecond;
      }
      Results res = await _connection.query(sql, values);
      if (DateTime.now().millisecond - _lastConn > 60000) {
        _connection.close();
        _connection = null;
      }
      return res;
    } else {
      return await _runQueryNotVerifiedUser(sql, values);
    }
  }

  static Future<Results> _runQueryNotVerifiedUser(String sql, [List<Object> values]) async {
    ConnectionSettings settings = new ConnectionSettings(
      host: '178.18.207.118',
      port: 3306,
      user: 'yorglass_read',
      password: '?KWOrrIM0k7g',
      db: 'yorglass_ik',
    );

    MySqlConnection conn = await MySqlConnection.connect(settings);
    Results res = await conn.query(sql, values);
    conn.close();
    return res;
  }
}
