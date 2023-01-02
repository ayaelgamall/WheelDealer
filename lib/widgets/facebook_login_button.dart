import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:flutter/material.dart';

class FacebookLoginButton extends StatelessWidget {
  const FacebookLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          AuthenticationService().signInWithFacebook();
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xff1877f2))),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                width: 24,
                image: AssetImage('lib/assets/images/logos/facebook.png'),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Continue with Facebook",
                style: TextStyle(fontSize: 18, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
