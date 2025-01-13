import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
import 'package:musify/common/widgets/button/basic_app_button.dart';
import 'package:musify/core/config/assets/app_vectors.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/data/models/auth/create_user_req.dart';
import 'package:musify/domain/usecases/auth/signup.dart';
import 'package:musify/presentation/auth/pages/signin.dart';
import 'package:musify/presentation/home/pages/home_nav.dart';
import 'package:musify/service_locator.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
          //hideAction: true,
          title: Row(
        children: [
          Text(
            'Play',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '.co',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _registerText(),
            const SizedBox(
              height: 40,
            ),
            _fullNameField(context),
            const SizedBox(
              height: 20,
            ),
            _emailField(context),
            const SizedBox(
              height: 20,
            ),
            _passwordField(context),
            const SizedBox(
              height: 30,
            ),
            BasicAppButton(
                onPressed: () async {
                  var result = await sl<SignupUseCase>().call(
                      params: CreateUserReq(
                          fullName: _fullName.text.toString().trim(),
                          email: _email.text.toString().trim(),
                          password: _password.text.toString().trim()));
                  result.fold((l) {
                    var snackbar = SnackBar(content: Text(l));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }, (r) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeNavPage()),
                        (route) => false);
                  });
                },
                title: 'Create Account'),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?',
                    style: TextStyle(
                      fontSize: 16,
                      color: context.isDarkMode
                          ? AppColors.grey
                          : AppColors.darkGrey,
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SigninPage()));
                  },
                  child: const Text('Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: _fullName,
      decoration: InputDecoration(
        hintText: 'Enter your name',
        hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.isDarkMode ? AppColors.grey : AppColors.darkGrey),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: InputDecoration(
        hintText: 'Enter your email',
        hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.isDarkMode ? AppColors.grey : AppColors.darkGrey),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: InputDecoration(
        hintText: 'Create a Password',
        hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.isDarkMode ? AppColors.grey : AppColors.darkGrey),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
