import 'package:flutter/material.dart';
import '../RegisterPages/loginPage.dart';
import '../RegisterPages/registerPage.dart';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}
class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially, show login page
  bool showLoginPage = true;
  //toggle between two page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return Loginpage(onTap: togglePages);
    }else{
      return RegisterPage(onTap: togglePages);
    }
  }
}

