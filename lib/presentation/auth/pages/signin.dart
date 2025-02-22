import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music/common/widgets/appbar/app_bar.dart';
import 'package:music/common/widgets/button/basic_app_button.dart';
import 'package:music/core/configs/assets/app_vectors.dart';
import 'package:music/data/models/auth/signin_user_req.dart';
import 'package:music/domain/usecases/auth/signin_use_case.dart';
import 'package:music/presentation/auth/pages/signup.dart';
import 'package:music/presentation/root/pages/root.dart';
import 'package:music/service_locator.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signUpText(context),
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _registerText(),
              SizedBox(
                height: 50,
              ),
              _emailField(context),
              SizedBox(
                height: 20,
              ),
              _passwordField(context),
              SizedBox(
                height: 20,
              ),
              BasicAppButton(
                onPressed: () async {
                  var result = await sl<SignInUseCase>().call(
                      params: SigninUserReq(
                    email: _email.text.toString(),
                    password: _password.text.toString(),
                  ));
                  result.fold((l) {
                    var snackBar = SnackBar(
                      content: Text(l),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }, (r) {
                    var snackBar = SnackBar(
                      content: Text(r),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => RootPage()),
                        (route) => false);
                  });
                },
                title: 'Sign In',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerText() {
    return Text(
      'Sign In',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: InputDecoration(
        hintText: 'Enter Username Or Email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: InputDecoration(
        hintText: 'Password',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signUpText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not A Member?',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(),
              ),
            );
          },
          child: Text(
            'Register Now',
            style: TextStyle(color: Color(0xFF288CE9)),
          ),
        )
      ],
    );
  }
}
