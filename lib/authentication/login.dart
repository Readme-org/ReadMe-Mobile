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
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _logoAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(_logoAnimationController);

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _logoAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.5; // Slow down animations for better UX
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.all(_logoAnimation.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade400.withOpacity(0.5),
                      ),
                      child: child,
                    );
                  },
                  child: FlutterLogo(size: 100),
                ),
                const SizedBox(height: 30),
                _buildAnimatedTextField(_usernameController, 'Username'),
                const SizedBox(height: 12.0),
                _buildAnimatedTextField(_passwordController, 'Password', obscureText: true),
                const SizedBox(height: 24.0),
                ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: ElevatedButton(
                    onPressed: () async {
                      _buttonAnimationController.forward().then((value) => _buttonAnimationController.reverse());
                      await _performLogin(request, context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade900,
                    ),
                    child: const Text('Login'),
                  ),
                ),
                _buildRegisterText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildRegisterText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account? "),
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
    );
  }

  Future<void> _performLogin(CookieRequest request, BuildContext context) async {
  String username = _usernameController.text;
  String password = _passwordController.text;

  final response = await request.login(
    "http://127.0.0.1:8000/auth/login/",
    {'username': username, 'password': password},
  );

  if (request.loggedIn) {
    String message = response['message'];
    String uname = response['username'];
    int uid = response.containsKey('uid') ? response['uid'] : -1;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomebookPage()), // Asumsikan HomebookPage siap menerima dan menggunakan data pengguna
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$message Selamat datang, $uname.")));
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Gagal'),
        content: Text(response['message']),
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
}
}
