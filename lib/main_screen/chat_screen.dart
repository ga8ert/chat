
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/providers/authentication_provider.dart';
import 'package:untitled1/widgets/bottom_chat_field.dart';
import 'package:untitled1/widgets/chat_app_bar.dart';
import 'package:untitled1/widgets/chat_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {

    //get arguments passed from previous screen
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    //get the contactUID from the arguments
    final contactUID = arguments[Constants.contactUID];
    //get the contactName from the arguments
    final contactName = arguments[Constants.contactName];
    //get the contactImage from the arguments
    final contactImage = arguments[Constants.contactImage];
    //get the groupId from the arguments
    final groupId = arguments[Constants.groupId];
    //check if the groupId is empty - then is a chat with a friend else its a group chat
    final isGroupChat = groupId.isNotEmpty ? true : false;


    return Scaffold(
      appBar: AppBar(
        title: ChatAppBar(contactUID: contactUID),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:   LinearGradient(
            colors: [
              Color(0xFF6BA3BE),
              Color(0xFF0C969C),
              Color(0xFF0A7075),
              Color(0xFF032F30),
              Color(0xFF031716),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(
                  child: ChatList(contactUID: contactUID, groupId: groupId),
              ),
              BottomChatField(
                contactUID: contactUID,
                  groupId: groupId,
                  contactImage: contactImage,
                  contactName: contactName,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
