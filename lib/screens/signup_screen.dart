import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/screens/main_screen.dart';
import 'package:instagram/screens/signin_screen.dart';
import 'package:instagram/services/auth_service.dart';
import 'package:instagram/utils/show_snackbar.dart';
import 'package:instagram/widgets/custom_button.dart';
import 'package:instagram/widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void register() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthService().signUp(
      username: _usernameController.text.toLowerCase(),
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'Success') {
      Navigator.of(context).pushReplacement(MainScreen.route());
    } else {
      showSnackbar(context, res);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                SvgPicture.asset('assets/logo.svg', color: Colors.black),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 14),
                CustomButton(
                  width: double.infinity,
                  height: 40,
                  label: 'Sign Up',
                  color: accentBlue,
                  textColor: Colors.white,
                  isLoading: _isLoading,
                  onTap: register,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(SignInScreen.route());
                      },
                      child: const Text(
                        "Already have an account? Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
