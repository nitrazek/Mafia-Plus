import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/LoginViewModel.dart';
import 'Menu.dart';
import 'Register.dart';
import 'package:animate_do/animate_do.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with RouteAware {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    context.read<LoginViewModel>().reset();
    _loginController.clear();
    _passwordController.clear();
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    context.read<LoginViewModel>().reset();
    _loginController.clear();
    _passwordController.clear();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Color(0xFF8E44AD),
                    Color(0xFFc8a2d8)
                  ]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40,),
              Center(
                child: Image.asset(
                  'assets/images/mafialogo.png',
                  width: screenWidth * 0.40,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Mafia+",style: TextStyle(color: Colors.white, fontSize: 35),),
                      Text("Login",style: TextStyle(color: Colors.white, fontSize: 20),)
                    ]
                ),
              ),
              Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 15,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(
                                color: Color(0x6D8E44AD),
                                blurRadius: 20,
                                offset: Offset(0, 10)
                              )]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey))
                                  ),
                                  child: TextField(
                                    controller: _loginController,
                                    decoration: const InputDecoration(
                                      hintText: "Login",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                          const SizedBox(height: 35,),
                          Consumer<LoginViewModel>(
                              builder: (context, viewModel, child) {
                                return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0x6D8E44AD),
                                      minimumSize: Size(screenWidth-150, 50)
                                    ),
                                    onPressed: () async {
                                      bool isLogged = await viewModel.login(
                                          _loginController.text,
                                          _passwordController.text
                                      );
                                      if(isLogged) {
                                        Fluttertoast.showToast(
                                            msg: "Successful login",
                                            toastLength: Toast.LENGTH_SHORT
                                        );
                                        if(!context.mounted) return;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const MenuPage())
                                        );
                                      }
                                    },
                                    child: const Text(
                                        'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ))
                                );
                              }
                          ),
                          const SizedBox(height: 25.0),
                          const Text("Don't have an account?"),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0x6D8E44AD),
                                minimumSize: Size(screenWidth-150, 50)
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterPage()),
                              );
                            },
                            child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ))
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        )
    );
  }
}
