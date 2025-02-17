import 'package:untitled1/constants.dart';

class LastMessageModel{
  String senderUID;
  String contactUID;
  String contactName;
  String contactImage;
  String message;
  MessageEnum messageType;
  DateTime timeSent;
  bool isSeen;

  LastMessageModel({
    required this.contactImage,
    required this.contactName,
    required this.contactUID,
    required this.messageType,
    required this.message,
    required this.senderUID,
    required this.isSeen,
    required this.timeSent,
  });

  //to map
  Map<String,dynamic> toMap(){
    return{
      Constants.senderUID: senderUID,
      Constants.contactUID: contactUID,
      Constants.contactName: contactName,
      Constants.contactImage: contactImage,
      Constants.message: message,
      Constants.messageType: messageType.name,
      Constants.timeSent: timeSent.microsecondsSinceEpoch,
      Constants.isSeen: isSeen,
    };
  }

  //from map
  factory LastMessageModel.fromMap(Map<String,dynamic> map){
    return LastMessageModel(
        senderUID: map[Constants.senderUID] ?? '',
        contactUID: map[Constants.contactUID] ?? '',
        contactName: map[Constants.contactName] ?? '',
        contactImage: map[Constants.contactImage] ?? '',
        message: map[Constants.message] ?? '',
        messageType: map[Constants.messageType].toString().toMessageEnum(),
        timeSent: DateTime.fromMicrosecondsSinceEpoch(map[Constants.timeSent]),
        isSeen: map[Constants.isSeen] ?? false,
    );
  }

  copyWith({
    required String contactUID,
    required String contactName,
    required String contactImage,
  }){
    return LastMessageModel(
        contactImage: contactImage,
        contactName: contactName,
        contactUID: contactUID,
        messageType: messageType,
        message: message,
        senderUID: senderUID,
        isSeen: isSeen,
        timeSent: timeSent,
    );
  }
}
