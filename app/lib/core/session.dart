
import 'package:grpc/grpc.dart';

class Session {
  ClientChannel _channel;
  String _token;

  Session(String host, int port) {
    this._channel = ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }

  Future<void> login(String userId, String password) async {
    // TODO
  }

  ClientChannel get getChannel {
    return _channel;
  }

  String get getToken {
    return _token;
  }

}