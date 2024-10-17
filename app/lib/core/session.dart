
class Session {
  String _host;
  int _port;
  String _token;

  Session(this._host, this._port);

  Future<void> login(String userId, String password) async {
    // TODO
  }

  String get getHost {
    return _host;
  }

  int get getPort {
    return _port;
  }

  String get getToken {
    return _token;
  }

}