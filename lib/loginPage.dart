import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singscan/appController.dart';
import 'package:singscan/constants.dart';
import 'package:singscan/homePage.dart';
import 'package:singscan/widgets/LoadingDialog.dart';
import 'package:singscan/widgets/appTextForm.dart';
import 'package:singscan/widgets/cupertinoAlertDialog.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AppController>(builder: (context, controller, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(""),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                      width: 300,
                      height: 200,
                      child: Image.asset(
                        'assets/icons/aaaa.jpg',
                        fit: BoxFit.fitWidth,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: _loginFormKey,
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '??????????????????????????????',
                          ),
                        ),
                        AppTextFormNumber(
                          controller: username,
                          hintText: '??????????????????????????????',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '????????????????????????????????????????????????????????????????????????';
                            } else if (RegExp(r'\s').hasMatch(val)) {
                              return '????????????????????????????????????????????????';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '????????????????????????',
                          ),
                        ),
                        AppTextForm(
                            controller: password,
                            hintText: '????????????????????????',
                            isPassword: true,
                            validator: (val) {
                              final regExp = RegExp(
                                r'^(?=.*\d)(?=.*[a-zA-Z]).{0,}$',
                              );
                              if (val == null || val.isEmpty) {
                                return '??????????????????????????????????????????????????????';
                              }
                              if (val.length < 2 || val.length > 20) {
                                return '??????????????????????????????????????????????????????????????? 8 ?????????????????????????????????';
                              }
                              // if (!regExp.hasMatch(val)) {
                              //   return '????????????????????????????????????????????????????????????????????????';
                              // }
                              return null;
                            }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GestureDetector(
                    onTap: () async {
                      if (_loginFormKey.currentState!.validate()) {
                        try {
                          LoadingDialog.open(context);
                          final userdata = await controller.signIn(
                              tel: username.text, password: password.text);
                          //await controller.setToken();
                          if (!mounted) return;
                          LoadingDialog.close(context);
                          if (userdata == true) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return HomePage();
                            }));
                          } else {
                            LoadingDialog.close(context);
                            showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoQuestion(
                                      title: '??????????????????????????????????????????',
                                      content:
                                          '???????????????????????????????????????????????????????????????????????????????????????????????????????????????',
                                      press: () {
                                        Navigator.pop(context, true);
                                      },
                                    ));
                          }
                        } catch (e) {
                          LoadingDialog.close(context);
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoQuestion(
                                    title: '???????????????????????????????????????????????????????????????????????????',
                                    content: '??????????????????????????????????????????????????????????????????????????????',
                                    press: () {
                                      Navigator.pop(context, true);
                                    },
                                  ));
                        }
                      } else {}
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPrimaryColor),
                      child: Center(
                        child: Text(
                          '?????????????????????????????????',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
