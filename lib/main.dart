import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return CupertinoApp(
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
      ),
      home: CupertinoApp.router(
        routerConfig: router,
      ),
      builder: (context, child) {
        return CupertinoTheme(
          data: const CupertinoThemeData(brightness: Brightness.light),
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(platformBrightness: Brightness.light),
            child: child!,
          ),
        );
      },
    );
  }
}
