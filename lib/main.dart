import 'package:flutter/material.dart';
import 'package:localonibus/RouteGenerator.dart';
import 'package:localonibus/views/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localonibus/views/widgets/ScrollBehavior.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyBDNPBYZiA6kzWIhFBqVYQu4H0ZS_BJU3Y", appId: "1:1027803139568:web:d56ed21291dddd79f02135", messagingSenderId: "1027803139568", projectId: "localonibuscanoas")
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale("pt", "BR")],
      title: "Local Ônibus",
      themeMode: ThemeMode.light,
      theme: ThemeData(fontFamily: "OpenSans").copyWith(colorScheme: ColorScheme.light(
        primary: Colors.black26,
      )),
      home: Login(),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
