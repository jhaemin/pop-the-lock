import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pop_the_lock/game/game_screen.dart';
import 'package:pop_the_lock/main_menu/main_menu_screen.dart';
import 'package:pop_the_lock/settings/settings_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Center(
        child: MainMenuScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
  ],
);
