import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/authentication_provider.dart';
import '../widgets/app_bar_back_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  void getThemeMode() async {
    final savedthemeMode = await AdaptiveTheme.getThemeMode();
    if (savedthemeMode == AdaptiveThemeMode.dark) {
      setState(() {
        isDarkMode = true;
      });
    } else {
      setState(() {
        isDarkMode = false;
      });
    }
  }

  @override
  void initState() {
    getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    //get  the uid from arguments
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(onPressed: () {
          Navigator.pop(context);
        }),
        centerTitle: true,
        title: const Text('Settings'),
        actions: [
          currentUser.uid == uid
              ?
              //logout button
              IconButton(
                  onPressed: () async {
                    //create a dialog to confirm logout
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                  'Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await context
                                          .read<AuthenticationProvider>()
                                          .logout()
                                          .whenComplete(() {
                                        Navigator.pop(context);
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Constants.loginScreen,
                                          (routwe) => false,
                                        );
                                      });
                                    },
                                    child: const Text('Logout')),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.logout),
                )
              : const SizedBox(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Card(
              child: SwitchListTile(
                  title: const Text('Change Theme'),
                  secondary: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? Colors.white : Colors.black87),
                    child: Icon(
                      isDarkMode
                          ? Icons.nightlight_round
                          : Icons.wb_sunny_rounded,
                      color: isDarkMode ? Colors.black87 : Colors.white,
                    ),
                  ),
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                    if (value) {
                      AdaptiveTheme.of(context).setDark();
                    } else {
                      AdaptiveTheme.of(context).setLight();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
