
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gptchat/common/appcontext.dart';
import 'package:gptchat/chat_screen.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final routes = {
  '/chat': (context, {arguments}) => ChatScreen(),
};

// ignore: top_level_function_literal_block, missing_return
var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  final Function pageContentBuilder = routes[name] as Function;
  if (settings.arguments != null) {
    final Route route =
        MaterialPageRoute(builder: (context) => pageContentBuilder(context, arguments: settings.arguments));
    return route;
  } else {
    final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder(context));
    return route;
  }
};

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print(details.exceptionAsString());
  };
  AppContext.getAccountData().then((user){
     if(user.apikey != null && user.apikey!.isNotEmpty && (user.token == null || user.token!.isEmpty)){
       AppContext.doLogin(user.apikey!);
     }
  });
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('zh', 'CN'),
      title: 'ChatGPT',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF202123),
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          elevation: 3.0,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF202123),
          secondary: Colors.grey,
          // brightness: Brightness.light,
        ),
        textTheme:  const TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          bodyLarge: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        useMaterial3: true,
        primaryColor: const Color(0xFF202123),
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white12,
          foregroundColor: Colors.white70,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: IconThemeData(color: Colors.white54),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          elevation: 3.0,
        ),
        colorScheme: const ColorScheme.dark(
          // 添加这个 colorScheme
          primary: Colors.grey,
          secondary: Colors.grey,
          // brightness: Brightness.dark,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF171717),
          selectedItemColor: Colors.white70,
          unselectedItemColor: Colors.white38,
        ),
        iconTheme: const IconThemeData(color: Colors.white54),
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF343540),
        cardColor: const Color(0xFF1E1E1E),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 14),
            child: child!,
          ),
        );
      },
      home: ChatScreen(),
      onGenerateRoute: onGenerateRoute,
    );
  }

}
