import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/accounts/accounts_screen.dart';
import 'package:youtube_clone/presentation/screens/home/home_screen.dart';
import 'package:youtube_clone/presentation/screens/subscriptions/subscriptions_screen.dart';

import 'shorts/shorts_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: selectedIndex,
        builder: (context, _) {
          return IndexedStack(
            index: selectedIndex.value,
            children: const [
              HomeScreen(),
              ShortsScreen(),
              SubscriptionsScreen(),
              AccountsScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: selectedIndex,
        builder: (context, _) {
          return NavigationBar(
            selectedIndex: selectedIndex.value,
            destinations: [
              IconButton(
                onPressed: () {
                  selectedIndex.value = 0;
                },
                icon: const Icon(Icons.home),
              ),
              IconButton(
                onPressed: () {
                  selectedIndex.value = 1;
                },
                icon: const Icon(Icons.short_text),
              ),
              IconButton(
                onPressed: () {
                  selectedIndex.value = 2;
                },
                icon: const Icon(Icons.subscriptions),
              ),
              IconButton(
                onPressed: () {
                  selectedIndex.value = 3;
                },
                icon: const Icon(Icons.account_circle),
              ),
            ],
          );
        },
      ),
    );
  }
}
