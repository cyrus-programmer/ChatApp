import 'package:chatapp/helper/HelperFunction.dart';
import 'package:chatapp/screens/auth/LoginPage.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import '../../widgets/button.dart';
import '../../widgets/widgets.dart';
import '../HomePage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  String email = "";

  String password = "";

  String fullName = "";

  bool _isloading = false;

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Baithak",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          const Text("Join now to explore",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 5),
                          Image.asset("assets/images/register.png"),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                fullName = value;
                              });
                            },
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "Please Enter your Name";
                              }
                            },
                            obscureText: false,
                            decoration: inputDecoration.copyWith(
                                labelText: "Full Name",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Constant.primaryColor,
                                )),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                            obscureText: false,
                            decoration: inputDecoration.copyWith(
                                labelText: "Email",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Constant.primaryColor,
                                )),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: true,
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                            decoration: inputDecoration.copyWith(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Constant.primaryColor,
                                )),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              await register();
                            },
                            child: ButtonWidget(
                                backgroundColor: Constant.primaryColor,
                                text: "Sign Up",
                                textColor: Colors.white60),
                          ),
                          Text.rich(TextSpan(
                              text: "Already have an account?",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              children: [
                                TextSpan(
                                    text: " Login Now!",
                                    style: const TextStyle(
                                        color: Colors.blueGrey,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {
                                            nextScreen(
                                                context, const LoginPage())
                                          })
                              ]))
                        ],
                      )),
                ),
              ));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authService
          .registerUser(fullName, email, password)
          .then((value) async {
        if (value == true) {
          showSnackbar(context, Colors.green, "Register Successfully");

          // saving the shared preference state
          await HelperFunction.saveUserLoggedInKey(value);
          await HelperFunction.saveUserEmailKey(email);
          await HelperFunction.saveUserNameKey(fullName);
          // ignore: use_build_context_synchronously
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }
}
