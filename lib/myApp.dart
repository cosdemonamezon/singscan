import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singscan/appController.dart';
import 'package:singscan/homePage.dart';
import 'package:singscan/loginPage.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future<void> _checkToken() async {
    await context.read<AppController>().initialize();
    final _token = context.read<AppController>().token;
    if (_token != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}