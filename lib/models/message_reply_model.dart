import 'package:untitled1/constants.dart';

class MessageReplyModel{
  final String message;
  final String senderUID;
  final String senderName;
  final String senderImage;
  final MessageEnum messageType;
  final bool isMe;

  MessageReplyModel({
    required this.messageType,
    required this.message,
    required this.senderImage,
    required this.senderName,
    required this.senderUID,
    required this.isMe,
  });

  //to map
  Map<String,dynamic> toMap(){
    return{
      Constants.message: message,
      Constants.senderUID: senderUID,
      Constants.senderName: senderName,
      Constants.senderImage: senderImage,
      Constants.messageType: messageType.name,
      Constants.isMe: isMe,
    };
  }

  //from map

  factory MessageReplyModel.fromMap(Map<String,dynamic>map){
    return MessageReplyModel(
        messageType: map[Constants.messageType].toString().toMessageEnum(),
        message: map[Constants.message] ?? '',
        senderImage: map[Constants.senderImage] ?? '',
        senderName: map[Constants.senderName] ?? '',
        senderUID: map[Constants.senderUID] ?? '',
        isMe: map[Constants.isMe] ?? false,
    );
  }

}