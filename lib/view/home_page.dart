import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy/main.dart';
import 'package:shopeasy/view/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://i.pinimg.com/736x/2b/10/af/2b10afa3ae56dbf2259b0556f79200c4.jpg',
                width: 150, // Ubah sesuai kebutuhan
                height: 150, // Ubah sesuai kebutuhan
                fit: BoxFit.cover, // Menyesuaikan agar gambar tidak terdistorsi
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 50, color: Colors.red);
                },
              ),
              SizedBox(height: 20),
              Text(
                'Selamat Datang di Shoeasy',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Text(
                'Welcome, $_username', // Menampilkan username
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              
              Text(
                'Shoeasy adalah aplikasi e-commerce sederhana yang dirancang untuk memberikan pengalaman belanja sepatu yang mudah,' 
                'cepat, dan nyaman. Aplikasi ini memungkinkan pengguna untuk menjelajahi berbagai koleksi sepatu, melihat detail produk, '
                'serta melakukan manajemen produk dengan fitur CRUD (Create, Read, Update, Delete).',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Tujuan Aplikasi',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Mempermudah pengguna dalam mencari dan membeli sepatu secara online.',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
                  Text('- Memberikan tampilan antarmuka yang menarik dan mudah digunakan.',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
                  Text('- Mengimplementasikan fitur CRUD API untuk pengelolaan produk.',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
                  Text('- Menyediakan fitur login dan validasi data pengguna.',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
                  Text('- Menampilkan halaman profil pengguna untuk personalisasi pengalaman.',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
                ],
              ),
              Text(
                'Tim pengembang',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Aplikasi ini dikembangkan oleh Ariadiva Putri BM dan Devi Wulandari sebagai bagian dari proyek tugas besar dalam pengembangan aplikasi mobile menggunakan Flutter.'

                'Dengan Shoeasy, kami berharap dapat memberikan solusi belanja sepatu yang lebih praktis dan efisien bagi semua pengguna. 🚀',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Navigator.pushReplacementNamed(context, '/menu_utama');
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                        );
                },
                child: Text('Mulai Belanja'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
