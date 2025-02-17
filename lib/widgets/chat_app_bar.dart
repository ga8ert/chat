import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/constants.dart';

import '../models/user_model.dart';
import '../providers/authentication_provider.dart';
import '../utilities/global_methods.dart';

class ChatAppBar extends StatefulWidget {
  const ChatAppBar({super.key, required this.contactUID});

  final String contactUID;

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthenticationProvider>().userStream(userID: widget.contactUID),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userModel =
        UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        return Row(
          children: [
            userImageWidget(
                imageUrl: userModel.image,
                radius: 20,
                onTap: (){
                  Navigator.pushNamed(context, Constants.profileScreen, arguments: userModel.uid);
                }
            ),
            SizedBox(width:  10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userModel.name, style: GoogleFonts.openSans(fontSize: 16),),
                Text('Online',
                  // userModel.isOnline
                  // ? 'Online'
                  // : 'Last seen ${GlobalMethods.formatTimestamp(userModel.lastSeen)}',
                  style:  GoogleFonts.openSans(fontSize: 12),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
