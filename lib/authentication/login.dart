import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme/authentication/user.dart';
import 'package:readme/authentication/register.dart';
import 'package:readme/modules/home-page/HomeBookPage.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        theme: ThemeData(
            primarySwatch: Colors.blue,
    ),
    home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
            appBar: AppBar(
                title: const Text('Login'),
            ),
            body: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                              labelText: 'Username',
                          ),
                      ),
                      const SizedBox(height: 12.0),
                      TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                          ),
                          obscureText: true,
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                          onPressed: () async {
                              String username = _usernameController.text;
                              String password = _passwordController.text;

                              // final response = await request.login("https://readme-c11-tk.pbp.cs.ui.ac.id/auth/login/", {

                              // For testing * Uncomment ketika ingin uji coba melalui runserver :), tapi di comment line atas
                              final response = await request.login("http://127.0.0.1:8000/auth/login/", {
                              
                              'username': username,
                              'password': password,
                              });
                  
                              if (request.loggedIn) {                                    
                                  String message = response['message'];
                                  String uname = response['username'];

                                  biguname = UserData(isLoggedIn: true, username: uname);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomebookPage()),
                                  );
                                  ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                          SnackBar(content: Text("$message Selamat datang, $uname.")));
                                  } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          title: const Text('Login Gagal'),
                                          content:
                                              Text(response['message']),
                                          actions: [
                                              TextButton(
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                      Navigator.pop(context);
                                                  },
                                              ),
                                          ],
                                      ),
                                  );
                              }
                          },
                          child: const Text('Login'),
                      ),
                      // Tombol untuk register
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => RegisterPage()), 
                                );
                              },
                              child: Text(
                                'Register here',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                ),
            ),
        );
    }
}
