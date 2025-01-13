import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musify/common/helpers/is_dark_mode.dart';
import 'package:musify/common/widgets/appbar/app_bar.dart';
import 'package:musify/common/widgets/button/basic_app_button.dart';
import 'package:musify/core/config/assets/app_vectors.dart';
import 'package:musify/core/config/theme/app_colors.dart';
import 'package:musify/data/models/auth/signin_user_req.dart';
import 'package:musify/domain/usecases/auth/siginin.dart';
import 'package:musify/presentation/auth/pages/signup.dart';
import 'package:musify/presentation/home/pages/home_nav.dart';
import 'package:musify/service_locator.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
          //action: Container(),
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
            _signinText(),
            const SizedBox(
              height: 40,
            ),
            _usernameOrEmailField(context),
            const SizedBox(
              height: 20,
            ),
            _passwordField(context),
            const SizedBox(
              height: 30,
            ),
            BasicAppButton(
                onPressed: () async {
                  var result = await sl<SigninUseCase>().call(
                      params: SigninUserReq(
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
                title: 'Sign in'),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?',
                    style: TextStyle(
                      fontSize: 16,
                      color: context.isDarkMode
                          ? AppColors.grey
                          : AppColors.darkGrey,
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: const Text('Create an Account',
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

  Widget _signinText() {
    return const Text(
      'Welcome Back!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _usernameOrEmailField(BuildContext context) {
    return TextField(
        controller: _email,
        decoration: InputDecoration(
          hintText: 'Enter Username or Email',
          hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.isDarkMode ? AppColors.darkGrey : AppColors.grey),
        ));
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
        controller: _password,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.isDarkMode ? AppColors.darkGrey : AppColors.grey),
        ));
  }
}
