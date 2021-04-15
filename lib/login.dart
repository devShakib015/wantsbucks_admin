import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks_admin/other%20pages/loading.dart';
import 'package:wantsbucks_admin/providers/auth_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("WantsBucks"),
            ),
            body: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Admin Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 26,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Can't be empty";
                            } else if (!value.contains("@") ||
                                !value.contains(".")) {
                              return "Invalid Email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "kent234@gmail.com",
                            labelText: "Email",
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passController,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Can't be empty";
                            } else if (value.length < 6) {
                              return "Password is at least 6 characters.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.security),
                            hintText: "Your Secured Password",
                            labelText: "Password",
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              // final user =
                              //     await Future.delayed(Duration(seconds: 3));
                              final user = await Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .signIn(context, _emailController.text,
                                      _passController.text);

                              if (user == null) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
