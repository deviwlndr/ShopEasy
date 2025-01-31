import 'package:flutter/material.dart';

class DataDiriPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Data Diri',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProfileCard(
                    name: 'Ariadiva Putri',
                    npm: '714220050',
                    imagePath: 'https://i.pinimg.com/736x/87/94/d6/8794d6d4080dc86b7ec5d972ed60f986.jpg', // Gambar untuk Ariadiva
                  ),
                  SizedBox(width: 16),
                  _buildProfileCard(
                    name: 'Devi Wulandari',
                    npm: '714220054',
                    imagePath: 'https://i.pinimg.com/736x/87/94/d6/8794d6d4080dc86b7ec5d972ed60f986.jpg', // Gambar untuk Devi
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({required String name, required String npm, required String imagePath}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 200,
        height: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(imagePath), // Gambar dari assets
              ),
              SizedBox(height: 12),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 4),
              Text(
                'NPM: $npm',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
