import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/authentication/login_screen.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/main_screen/my_chats_lscreen.dart';
import 'package:untitled1/main_screen/groups_screen.dart';
import 'package:untitled1/main_screen/people_screen.dart';
import 'package:untitled1/providers/authentication_provider.dart';
import 'package:untitled1/utilities/global_methods.dart';

import '../utilities/assets_manager.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  final List<Widget> pages = const [
    PeopleScreen(),
    MyChatsScreen(),
    GroupsScreen(),
  ];

  @override
   Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('GChat'),
          centerTitle: true,
          actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: userImageWidget(
              imageUrl: authProvider.userModel!.image,
              radius: 20,
              onTap: (){
                //navigate to user profile with uid as argument
                Navigator.pushNamed(context,
                    Constants.profileScreen,
                    arguments: authProvider.userModel!.uid
                );

              }),
        ),
      ]),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.globe,size: 35,),
              label: 'People',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2_fill,size: 35),
              label: 'Chats',

            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.group,size: 35),
              label: 'Groups',
            ),

          ],
          currentIndex: currentIndex,
          onTap: (index) {
            //animate to the page
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }
}
