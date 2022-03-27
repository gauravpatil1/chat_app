import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../controllers/auth_controller.dart';
import '../widgets/widgets.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      bool isPortrait = orientation == Orientation.portrait;
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Visibility(
                  visible: (!isPortrait &&
                          MediaQuery.of(context).viewInsets.bottom > 0)
                      ? false
                      : true,
                  child: const AuthHeaderWidget(
                    isLoginPage: false,
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Visibility(
                            visible: (!isPortrait &&
                                    MediaQuery.of(context).viewInsets.bottom >
                                        0)
                                ? false
                                : true,
                            child: const AuthWelcomeMessageWidget(),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Email Address',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !EmailValidator.validate(value)) {
                                        return 'Enter correct email address';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                    ),
                                    validator: (value) {
                                      if (value!.length > 8) {
                                        return 'Password should have maximum of 8 characters';
                                      } else if (value.length < 5) {
                                        return 'Password should have minimum of 5 characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                  TextFormField(
                                    controller: _confirmPassordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Confirm Password',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          value != _passwordController.text) {
                                        return 'Password and confirmation password do not match';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const AuthSocialWidget(),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (!isPortrait &&
                              MediaQuery.of(context).viewInsets.bottom > 0)
                          ? false
                          : true,
                      child: AuthBottomButtonWidget(
                        isLoginPage: false,
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            AuthController.instance.signUp(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
