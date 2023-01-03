import 'package:beta1/Screens/successful_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Screens/login_screen.dart';
import './Screens/signup_screen.dart';
import './Screens/welcome_screen.dart';
import './Models/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
      routes: {
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
    );
  }
}
