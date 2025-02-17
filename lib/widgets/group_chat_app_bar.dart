import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/utilities/global_methods.dart';
import '../providers/authentication_provider.dart';

class GroupChatAppBar extends StatefulWidget {
  const GroupChatAppBar({super.key, required this.groupId});

  final String groupId;

  @override
  State<GroupChatAppBar> createState() => _GroupChatAppBar();
}

class _GroupChatAppBar extends State<GroupChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthenticationProvider>().userStream(userID: widget.groupId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final groupModel =
        GroupModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        return Row(
          children: [
            userImageWidget(
                imageUrl: groupModel.image,
                radius: 20,
                onTap: (){
                 //navigate to group settings screen
                }
            ),
            SizedBox(width:  10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(groupModel.groupName),
                Text('Group description or group members',
                  style:  TextStyle(fontSize: 12),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
