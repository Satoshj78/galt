import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:galt/access/creationleague_page.dart';
import 'access/SignIn_page.dart';
import 'access/SignUp_page.dart';
import 'access/welcome_page.dart';
import 'pages/home_page.dart';
import 'access/introduction_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GaltApp());
}

class GaltApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GALT',
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.green),
          titleTextStyle: TextStyle(color: Colors.green, fontSize: 20),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          labelStyle: TextStyle(color: Colors.green),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/SignInPage': (context) => SignInPage(),
        '/SignUpPage': (context) => SignUpPage(),
        '/home': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
          return HomePage(leagueName: args['leagueName']!, userEmail: args['userEmail']!);
        }, // Passa i parametri
        '/CreationLeaguePage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
          return CreationLeaguePage(userEmail: args['userEmail']!);
        },
        '/IntroductionPage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
          return IntroductionPage(userEmail: args['userEmail']!);
        },
      },
    );
  }
}
