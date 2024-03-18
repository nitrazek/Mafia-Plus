import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/LoginViewModel.dart';
import 'Menu.dart';
import 'Register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
      appBar: AppBar(
        title: const Text('Mafia+'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/mafialogo.png',
                width: screenWidth * 0.65,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Login', // Napis po angielsku pod obrazkiem
              style: TextStyle(
                fontSize: 36.0, // Dostosuj rozmiar czcionki według potrzeb
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(labelText: 'Login'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32.0),
            Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return ElevatedButton(
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
                  child: const Text('Login')
                );
              }
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
