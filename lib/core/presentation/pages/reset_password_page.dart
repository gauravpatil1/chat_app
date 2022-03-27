import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../controllers/auth_controller.dart';
import '../widgets/widgets.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 60),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: const Text(
                      'Link to reset password will be sent on the email provided below.\nPlease use that link to reset password.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AuthBottomButtonWidget(
              isLoginPage: false,
              function: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  AuthController.instance.resetPassword(
                    _emailController.text.trim(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
