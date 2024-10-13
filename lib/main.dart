import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx_task/controller/add_user_provider.dart';
import 'package:totalx_task/controller/home_provider.dart';
import 'package:totalx_task/firebase_options.dart';
import 'package:totalx_task/view/home_page.dart';
import 'package:totalx_task/view/Auth_screens/login_page.dart';
import 'package:totalx_task/view/Auth_screens/otp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var auth = FirebaseAuth.instance;
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: auth.currentUser != null ? HomePage() : LoginPage(),
      ),
    );
  }
}
