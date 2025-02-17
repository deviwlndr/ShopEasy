import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopeasy/service/auth_manager.dart';
import 'package:shopeasy/view/data_diri.dart';
import 'package:shopeasy/view/home_page.dart';
import 'package:shopeasy/view/login_page.dart';
import 'package:shopeasy/view/menu_utama.dart';
import 'package:shopeasy/service/manage_product.dart';


void main() {
  runApp(ShopEasyApp());
}

class ShopEasyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopEasy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List halaman
  final List<Widget> _pages = [
    HomePage(),
    DataDiriPage(),
    MenuUtamaPage(),
    ManagePage(),
    LoginPage(),
  ];

  





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ShopEasy',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: const Color.fromARGB(255, 71, 145, 165),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 252, 211, 240),
        actions: [
         IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 176, 173, 250),
        color: Colors.white,
        buttonBackgroundColor: const Color.fromARGB(255, 184, 213, 227),
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        index: _currentIndex,
        items: <Widget>[
          Icon(Icons.home_filled, size: 30, color: Colors.blue),
          Icon(Icons.person, size: 30, color: Colors.blue),
          Icon(Icons.list, size: 30, color: Colors.blue),
          Icon(Icons.inventory, size: 30, color: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

    void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout();
                Navigator.pushAndRemoveUntil(
// ignore: use_build_context_synchronously
                  dialogContext,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}
