import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          AuthenticationService().signInWithGoogle();
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                width: 24,
                image: AssetImage('lib/assets/images/logos/google.png'),
              ),
              SizedBox(
                width: 10,
              ),
              Text("Continue with Google",
                  style: TextStyle(
                    fontSize: 18,
                  ) //Todo change to be related to the theme
                  )
            ],
          ),
        ),
      ),
    );
  }
}
