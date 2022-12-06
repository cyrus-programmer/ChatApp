// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:chatapp/screens/auth/RegisterPage.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/database_services.dart';
import 'package:chatapp/widgets/button.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/HelperFunction.dart';
import '../../shared/constants.dart';
import '../HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  String email = "";

  String password = "";

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
                          Text(
                            "Baithak",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 10),
                          Text("Join others in Baithak to know what's going on",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                          SizedBox(height: 10),
                          Image.asset("assets/images/group.png"),
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
                          InkWell(
                            onTap: () async {
                              await login();
                            },
                            child: ButtonWidget(
                                backgroundColor: Constant.primaryColor,
                                text: "Sign In",
                                textColor: Colors.white60),
                          ),
                          Text.rich(TextSpan(
                              text: "Don't have an account yet?",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              children: [
                                TextSpan(
                                    text: " Register Now!",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          {nextScreen(context, RegisterPage())})
                              ]))
                        ],
                      )),
                ),
              ));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authService.loginUser(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .getUserData(email);
          showSnackbar(context, Colors.green, "Login Successfully");

          // saving the shared preference state
          await HelperFunction.saveUserLoggedInKey(value);
          await HelperFunction.saveUserEmailKey(email);
          await HelperFunction.saveUserNameKey(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, HomePage());
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
