import 'package:flutter/material.dart';
import 'package:shopeasy/main.dart';
import 'package:shopeasy/model/login_model.dart';
import 'package:shopeasy/service/api_service.dart';
import 'package:shopeasy/service/auth_manager.dart';
import 'package:shopeasy/view/login_screen.dart';
import 'package:shopeasy/view/home_page.dart';
import 'package:shopeasy/view/register_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordHidden = true; // Untuk toggle password visibility
  final ApiServices _dataService = ApiServices(); // untuk memanggil API
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Validasi form
  final _usernameController = TextEditingController(); // Controller username
  final _passwordController = TextEditingController(); // Controller password
  final _roleController = TextEditingController(); // Controller role

  // Method untuk mengecek apakah user sudah login
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    bool isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  // Validasi untuk username, password, dan role
  String? _validateUsername(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Role Harus diisi';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  void showWelcomePopup(String username) {
    showDialog(
      context: context,
      barrierDismissible: false, // Agar dialog tidak bisa ditutup dengan tap di luar
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitPouringHourGlass(
                color: Colors.green, // Ganti warna sesuai kebutuhan
                size: 50.0, // Ukuran spinner
              ),
              SizedBox(height: 20),
              Text(
                'Selamat datang, $username! 👋',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Selamat datang!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );

    // Close the popup after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E6F0), // Warna latar belakang sesuai tema
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey, // Menambahkan key untuk form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Selamat Datang di Shopeasy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Silakan masuk untuk melanjutkan',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                SizedBox(height: 32),
                // Username Field
                TextFormField(
                  controller: _usernameController,
                  validator: _validateUsername,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.email, color: Colors.blue.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade700),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  validator: _validatePassword,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade700),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Role Dropdown
                SizedBox(height: 20),
                TextFormField(
                  controller: _roleController,
                  validator: _validateRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    final isValidForm = _formKey.currentState!.validate();
                    if (isValidForm) {
                      print("Form is valid, proceeding with login...");
                      final postModel = LoginInput(
                        username: _usernameController.text,
                        password: _passwordController.text,
                        role: _roleController.text,
                      );

                      LoginResponse? res = await _dataService.login(postModel);
                      print("API Response: ${res?.message}");

                      if (res != null && res.message == 'Login successful') {
                        await AuthManager.login(_usernameController.text);
                        showWelcomePopup(_usernameController.text);

                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false,
                          );
                        });
                      } else {
                        displaySnackbar(res?.message ?? 'Terjadi kesalahan');
                      }
                    } else {
                      print("Form is invalid");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Masuk',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                // Register Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Belum punya akun? Daftar',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Display Snackbar
  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
