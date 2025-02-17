import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/last_message_model.dart';
import 'package:untitled1/providers/authentication_provider.dart';
import 'package:untitled1/providers/chat_provider.dart';
import 'package:untitled1/utilities/global_methods.dart';

import '../constants.dart';

class MyChatsScreen extends StatefulWidget {
  const MyChatsScreen({super.key});

  @override
  State<MyChatsScreen> createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CupertinoSearchTextField(
              placeholder: 'Search',
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                print(value);
              },
            ),
            Expanded(
              child: //steam the lastMessages
                  StreamBuilder<List<LastMessageModel>>(
                      stream:
                          context.read<ChatProvider>().getChatsListStream(uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Something went wrong'),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          final chatsList = snapshot.data!;
                          return ListView.builder(
                              itemCount: chatsList.length,
                              itemBuilder: (context, index) {
                                final chat = chatsList[index];
                                //check if we sent the last message
                                final isMe = chat.senderUID == uid;
                                //dis the last message correctly
                                final lastMessage = isMe
                                    ? 'You: ${chat.message}'
                                    : chat.message;
                                final dateTime = formatDate(chat.timeSent, [
                                  hh,
                                  ':',
                                  nn,
                                  ' ',
                                  am,
                                ]);
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: userImageWidget(
                                        imageUrl: chat.contactImage,
                                        radius: 30,
                                        onTap: (){},
                                      ),

                                      title: Text(chat.contactName,),
                                      subtitle: Text(
                                        lastMessage,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      trailing: Text(dateTime),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context, Constants.chatScreen,
                                          arguments: {Constants.contactUID: chat.contactUID,
                                            Constants.contactName: chat.contactName,
                                            Constants.contactImage: chat.contactImage,
                                            Constants.groupId: '',
                                          },
                                        );
                                      },
                                    ),
                                    const Divider(
                                      height: 0.0000001,
                                    ),
                                  ],
                                );
                              });
                        }
                        return Center(
                          child: Text('No chats yet'),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
