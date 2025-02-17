import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/utilities/global_methods.dart';
import 'package:untitled1/widgets/contact_message_widget.dart';
import 'package:untitled1/widgets/my_message_widgets.dart';

import '../models/message_model.dart';
import '../providers/authentication_provider.dart';
import '../providers/chat_provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.contactUID, required this.groupId});

  final String contactUID;
  final String groupId;
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    //current user uid
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    return StreamBuilder<List<MessageModel>>(
        stream: context
            .read<ChatProvider>()
            .getMessagesStream(userId: uid, contactUID: widget.contactUID, isGroup: widget.groupId),
        builder: (context,snapshot){
          if (snapshot.hasError){
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.data!.isEmpty){
            return Center(
              child: Text(
                'Start a conversation',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2
                ),
              ),
            );

          }

          if (snapshot.hasData){
            final messagesList = snapshot.data!;
            return  GroupedListView<dynamic, DateTime>(
              reverse: true,
              elements: messagesList,
              groupBy: (element) {
                return DateTime(
                  element.timeSent!.year,
                  element.timeSent!.month,
                  element.timeSent!.day,
                );
              },
              groupHeaderBuilder: (dynamic groupByValue) =>
                  buildDateTime(groupByValue),
              itemBuilder: (context, dynamic element) {
                //check if we sent the last message
                final isMe = element.senderUID == uid;
                return isMe ? Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2),
                  child: MyMessageWidgets(
                    message: element,
                  ),
                ): Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2),
                  child: ContactMessageWidgets(
                      message: element

                  ),
                );
              },

              groupComparator: (value1, value2)=>
                  value2.compareTo(value1),

              itemComparator: (item1, item2) {
                var firstItem = item1.timeSent;
                var secondItem = item2.timeSent;
                return secondItem!.compareTo(firstItem!);
              }, // optional
              useStickyGroupSeparators: true, // optional
              floatingHeader: true, // optional
              order: GroupedListOrder.ASC, // optional
              // optional
            );
          }
          return SizedBox();
        }

    );
  }
}
