import 'package:flutter/material.dart';
import 'package:sportify_app/pages/WelcomePage.dart';
import 'package:sportify_app/providers/Auth.dart';
import 'package:sportify_app/providers/TrackerInfo.dart';
import 'package:sportify_app/widgets/MainNavigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TrackerInfo(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              Provider.of<Auth>(context, listen: false)
                  .updateCurrentUser(FirebaseAuth.instance.currentUser);

              return MainNavigation();
            } else {
              return WelcomePage();
            }
          },
        ),
      ),
    );
  }
}
