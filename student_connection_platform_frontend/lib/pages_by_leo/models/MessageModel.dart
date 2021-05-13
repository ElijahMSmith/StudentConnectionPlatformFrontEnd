// import 'dart:collection';

class MessageModel {
  String type;
  String message;
  String time;
  MessageModel({this.type, this.message, this.time});

  // map to MessageModel object
  MessageModel.fromMap(Map<String, dynamic> map) {
    this.type = map['type'];
    this.message = map['message'];
    this.time = map['time'];
  }

  // MessageModel object to map
  Map<String, dynamic> toMap() {
    return {
      'type': this.type,
      'message': this.message,
      'time': this.time,
    };
  }
}
