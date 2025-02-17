import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/widgets/app_bar_back_button.dart';
import 'package:untitled1/widgets/friends_list.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  AppBarBackButton(
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        centerTitle: true,
        title:Text('Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CupertinoSearchTextField(
              placeholder: 'Search',
              style: const TextStyle(
                color: Colors.white
              ),
              onChanged: (value){
                print(value);
              },
            ),
            const Expanded(child: FriendsList(viewType: FriendViewType.friends)),
          ],
        ),
      ),
    );
  }
}
