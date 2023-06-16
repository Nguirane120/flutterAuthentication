import 'package:fluatter_auth/screen/home_screen.dart';
import 'package:fluatter_auth/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CheckAuth(),
    );
  }
}



class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

 
  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {

   bool isAuth = false;


  @override
  void initState() {

    super.initState();
    
  }

  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if(isAuth){
      child = HomeScreen();
    }else{
      child = LoginScreen();
    }
    return Scaffold(
      body: child,
    );
  }
}