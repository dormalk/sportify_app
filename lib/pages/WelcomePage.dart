import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_app/providers/Auth.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(fontSize: 50),
                  ),
                  Text(
                    'Join now to the growing community of Sportify!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Provider.of<Auth>(context, listen: false).googleLogin();
                },
                child: Ink(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.android,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'SignIn With Google',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'For a Demo version we allow to sign in only with google account',
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
