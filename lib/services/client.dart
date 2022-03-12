import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:anthealth_mobile/services/message/message_define.dart';

class Client {
  Socket? socket;
  String host;
  int port;
  String? _data;

  Client(this.host, this.port);

  void connect() {
    Socket.connect(host, port).then((Socket sock) {
      socket = sock;
      socket?.listen(dataHandler,
          onError: _errorHandler, onDone: _doneHandler, cancelOnError: false);
    }).catchError((e) {
      print("can not connect to server: " + e);
      exit(0);
    });
  }

  // Server
  void send(int msgID, dynamic msgData) {
    var m = SMessage(msgID, msgData.toString());
    socket?.add(m.toByteBuf());
  }

  // Socket listener
  void dataHandler(data) {
    Uint8List bdata = data as Uint8List;
    RMessage rMessage = RMessage(bdata);
    _data = rMessage.toString();
  }

  void _errorHandler(error, StackTrace trace) {
    print(error);
    socket?.close();
    exit(0);
  }

  void _doneHandler() {
    print("Disconnected to server ${host}:${port}");
  }

  // Handle data
  Future<String> getData() async {
    var tempData = "null";
    await Future.delayed(const Duration(milliseconds: 100), () => {});
    if(_data == null) await Future.delayed(const Duration(seconds: 2), () => {});
    tempData = _data.toString();
    removeData();
    return tempData;
  }

  void removeData() {
    _data = null;
  }

  ///đăng kí ng dùng mới
  SMessage Test211() {
    var j = {
      "account": "ttvucse@gmail.com",
      "password": '"123456"',
      "name": "Trần Tiến Vũ"
    };
    SMessage m = SMessage(2110, j.toString());
    return m;
  }

  ///đăng nhập
  SMessage Test212() {
    var j = {"account": "ttvucse@gmail.com", "password": '"123456"'};
    SMessage m = SMessage(2120, j.toString());
    return m;
  }

  ///thêm chỉ số
  SMessage Test221() {
    var j = {"type": 1, "value": '"170"', "creator": 10001};
    SMessage m = SMessage(2210, j.toString());
    return m;
  }

  ///lấy thông tin chỉ số
  SMessage Test222() {
    var j = {
      "type": 1,
      "start_time": DateTime.now().millisecondsSinceEpoch - 5 * 24 * 3600,
      "end_time": DateTime.now().millisecondsSinceEpoch
    };
    SMessage m = SMessage(2220, j.toString());
    return m;
  }
}
