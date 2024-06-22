
import 'package:cosmatic/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/screens/custom_navbar/custom_navbar.dart';
import 'package:cosmatic/screens/splash_screen/splash_screen.dart';
import 'package:cosmatic/screens/welcome/welcome.dart';
import 'package:cosmatic/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; 


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const Cosme());
}


class Cosme extends StatelessWidget {
  const Cosme({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: "BuyBuddy",
        theme: lightTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FireBaseAuthHelper.instance.getAuthChange,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Splash(screen: const CustomBottomNavBar());
            }
            else{
              return Splash(screen: const WelcomeScreen());
            }
          },
        ),
      ),
    );
  }
}