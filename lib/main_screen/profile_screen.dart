import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/models/user_model.dart';
import 'package:untitled1/providers/authentication_provider.dart';
import 'package:untitled1/utilities/global_methods.dart';
import 'package:untitled1/widgets/app_bar_back_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel!;

    //get user data from arguments
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(onPressed: () {
          Navigator.pop(context);
        }),
        centerTitle: true,
        title: const Text('Profile'),
        actions: [
          currentUser.uid == uid
              ?
              //logout button
              IconButton(
                  onPressed: () async {
                    //navigate to the settings screen with the uid as argument
                    await Navigator.pushNamed(
                      context,
                      Constants.settingsScreen,
                      arguments: uid,
                    );
                  },
                  icon: const Icon(Icons.settings),
                )
              : const SizedBox(),
        ],
      ),
      body: StreamBuilder(
        stream: context.read<AuthenticationProvider>().userStream(userID: uid),
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

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 30,
            ),
            child: Column(
              children: [
                Center(
                  child: userImageWidget(
                    imageUrl: userModel.image,
                    radius: 60,
                    onTap: () {
                      //navigate to user profile with uid as argument
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  userModel.name,
                  style: GoogleFonts.openSans(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userModel.phoneNumber,
                  style: GoogleFonts.openSans(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildFriendRequestButton(
                    currentUser: currentUser, userModel: userModel),
                const SizedBox(
                  height: 10,
                ),
                buildFriendButton(
                    currentUser: currentUser, userModel: userModel),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                      width: 40,
                      child: Divider(
                        color: Constants.sProjectColor,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'About Me',
                      style: GoogleFonts.openSans(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 40,
                      width: 40,
                      child: Divider(
                        color: Constants.sProjectColor,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                Text(
                  userModel.aboutMe,
                  style: GoogleFonts.openSans(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //friend request button
  Widget buildFriendRequestButton({
    required UserModel currentUser,
    required UserModel userModel,
  }) {
    if (currentUser.uid == userModel.uid &&
        userModel.friendRequestsUIDs.isNotEmpty) {
      return buildElevatedButton(
        onPressed: () {
          //navigate to friend requests screen
          Navigator.pushNamed(context, Constants.friendRequestsScreen);
        },
        label: 'View Friend Requests',
        width: MediaQuery.of(context).size.width * 0.7,
        backgroundColor: Constants.sProjectColor,
        textColor: Colors.white,
      );
    } else {
      //not in our profile
      return const SizedBox.shrink();
    }
  }

  //friends button
  Widget buildFriendButton({
    required UserModel currentUser,
    required UserModel userModel,
  }) {
    if (currentUser.uid == userModel.uid && userModel.friendsUIDs.isNotEmpty) {
      return buildElevatedButton(
        onPressed: () {
          //navigate to friends screen
          Navigator.pushNamed(context, Constants.friendsScreen);
        },
        label: 'View Friends',
        width: MediaQuery.of(context).size.width * 0.7,
        backgroundColor: Constants.fProjectColor,
        textColor: Constants.sProjectColor,
      );
    } else {
      if (currentUser.uid != userModel.uid) {
        //show cancel friend request button if the user sent us friend request
        // else show send friend request button
        if (userModel.friendRequestsUIDs.contains(currentUser.uid)) {
          //show send friend request button
          return buildElevatedButton(
            onPressed: () async {
              await context
                  .read<AuthenticationProvider>()
                  .cancelFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                showSnackBar(context, 'Friend request cancelled');
              });
            },
            label: 'Cancel Friend Request',
            width: MediaQuery.of(context).size.width * 0.7,
            backgroundColor: Constants.sProjectColor,
            textColor: Colors.white,
          );
        } else if (userModel.sendFriendRequestsUIDs.contains(currentUser.uid)) {
          return buildElevatedButton(
            onPressed: () async {
              await context
                  .read<AuthenticationProvider>()
                  .acceptFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                showSnackBar(
                    context, 'You are now friends with ${userModel.name}');
              });
            },
            label: 'Accept Friend Request',
            width: MediaQuery.of(context).size.width * 0.7,
            backgroundColor: Constants.sProjectColor,
            textColor: Colors.white,
          );
        } else if (userModel.friendsUIDs.contains(currentUser.uid)) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildElevatedButton(
                onPressed: () async {
                  //show unfriend dialog to ask the user if he is sure to unfriend
                  //the user
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Unfriend', textAlign: TextAlign.start,),
                        content:  Text(
                            'Are you sure you want to unfriend ${userModel.name} ?', textAlign: TextAlign.start ,),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                              onPressed: () async {
                                //remove friend
                                await context
                                    .read<AuthenticationProvider>()
                                    .removeFriend(friendID: userModel.uid)
                                    .whenComplete(() {
                                  showSnackBar(context, 'You are no longer friends');
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('Yes')),
                        ],

                      ),

                  );


                },
                label: 'Unfriend',
                width: MediaQuery.of(context).size.width * 0.35,
                backgroundColor: Constants.sProjectColor,
                textColor: Colors.white,
              ),
              buildElevatedButton(
                onPressed: () async{
                  //navigate to chat screen with the following arguments
                  //1. friend uid, 2. friend name, 3. friend image, 4. groupId with an empty string
                  await Navigator.pushNamed(context, Constants.chatScreen,
                      arguments: {
                        Constants.contactUID: userModel.uid,
                        Constants.contactName: userModel.name,
                        Constants.contactImage: userModel.image,
                        Constants.groupId: '',
                      });
                },
                label: 'Chat',
                width: MediaQuery.of(context).size.width * 0.35,
                backgroundColor: Constants.fProjectColor,
                textColor: Constants.sProjectColor,
              ),
            ],
          );
        } else {
          return buildElevatedButton(
              onPressed: () async {
                await context
                    .read<AuthenticationProvider>()
                    .sendFriendRequest(friendID: userModel.uid)
                    .whenComplete(() {
                  showSnackBar(context, 'Friend request sent');
                });
              },
              label: 'Send Friend Request',
              width: MediaQuery.of(context).size.width * 0.7,
              backgroundColor: Constants.sProjectColor,
              textColor: Colors.white,
          );

        }
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
    required double width,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return SizedBox(
      width: width,
      child:
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )
        ),
          onPressed: onPressed,
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              color: textColor
            ),
          )),
    );
  }
}
