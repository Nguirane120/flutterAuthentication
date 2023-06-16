import 'dart:convert';

import 'package:fluatter_auth/networwk/api_network.dart';
import 'package:fluatter_auth/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();
  var email;
  var password;
  final _scafoldKey = GlobalKey<ScaffoldMessengerState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(label: "Close", onPressed: (){}),
    );
    
    _scafoldKey.currentState!.showSnackBar(snackBar);
  }


 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4.0,
            color: Colors.white,
            margin: EdgeInsets.only(left: 20, right: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formkey,
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    style: TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email), hintText: "Email"),
                    validator: (emailValue) {
                      if (emailValue!.isEmpty) {
                        return "Please enter an email";
                      }

                      email = emailValue;

                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Color(0xFF000000),
                    ),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                    validator: (passwordValue) {
                      if (passwordValue!.isEmpty) {
                        return "Please enter somme text";
                      }
                      password = passwordValue;
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextButton(
                      onPressed: () {
                        if(_formkey.currentState!.validate()){
                            
                        _login();

                        debugPrint(email);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, right: 10),
                        child: Text(
                          _isLoading ? "Processing" : "Login",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          )
        ],
      ),
    );
  }

   void _login() async{
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email' : email,
      'password' : password
    };

    var res = await Network().authData(data, '/login');
    // print(res);
    var body = json.decode(res.body);
    print('USER INFO =====> ${body}');
    if(body['success']){

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()
          ),
      );
    }else{
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });

  }

}

