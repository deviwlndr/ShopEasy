import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopeasy/view/login_page.dart';
import 'package:shopeasy/model/login_model.dart';
import 'package:shopeasy/service/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEasy Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterPage> {
  bool _isPasswordHidden = true;

  // Controllers untuk form fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();

  final ApiServices _apiServices = ApiServices(); // Menggunakan ApiServices untuk register

  // GlobalKey untuk form validation
  final _formKey = GlobalKey<FormState>();

  // Menambahkan SnackBar dengan emoticon senyum
  void showLoadingSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              'Silakan menunggu proses registrasi... 😄',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        duration: Duration(seconds: 2), // Tampilkan SnackBar selama 2 detik
      ),
    );
  }

  // Validasi untuk username
 String? _validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username tidak boleh kosong';
  }
  if (value.length < 4) {
    return 'Username harus terdiri dari minimal 4 karakter';
  }
  return null;
}


  // Validasi untuk password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Validasi untuk role
  String? _validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Role tidak boleh kosong';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8E1F4), // Warna background seperti pada gambar
      appBar: AppBar(
        title: Text('Selamat Datang di ShopEasy'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Menggunakan GlobalKey untuk form validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Silakan Daftar untuk Melanjutkan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 30),
              // Username Field dengan validasi
              TextFormField(
                controller: _usernameController,
                validator: _validateUsername,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Password Field dengan validasi
              TextFormField(
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                validator: _validatePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Role Field dengan validasi
              TextFormField(
                controller: _roleController,
                validator: _validateRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // Validasi form
                  if (_formKey.currentState!.validate()) {
                    // Ambil data inputan dari controller
                    final registerInput = RegisterInput(
                      username: _usernameController.text,
                      password: _passwordController.text,
                      role: _roleController.text,
                    );

                    // Tampilkan SnackBar saat proses dimulai
                    showLoadingSnackbar();

                    // Panggil fungsi register API
                    RegisterResponse? response =
                        await _apiServices.register(registerInput);

                    if (response != null && response.message == 'Registration successful') {
                      // Jika registrasi sukses, arahkan ke login
                      Navigator.pop(context); // Kembali ke login
                    } else {
                      // Tampilkan pesan error jika gagal
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration failed')),
                      );
                    }
                  }
                },
                child: Text(
                  'Daftar',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman login
                },
                child: Text('Sudah punya akun? Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
