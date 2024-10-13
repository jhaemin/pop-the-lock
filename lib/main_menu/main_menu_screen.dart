import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pop the Lock',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CupertinoButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
            CupertinoButton(
              child: const Text('Start Game'),
              onPressed: () => GoRouter.of(context).push('/game'),
            ),
          ],
        ),
        // child: FilledButton(
        //   onPressed: () {
        //     GoRouter.of(context).push('/settings');
        //   },
        //   child: const Text('Settings'),
        // ),
      ),
    );
  }
}
