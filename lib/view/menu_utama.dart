import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MenuUtamaPage extends StatefulWidget {
  @override
  _MenuUtamaPageState createState() => _MenuUtamaPageState();
}

class _MenuUtamaPageState extends State<MenuUtamaPage> {
  List<dynamic> _produk = []; 
  bool _isLoading = true; 


  Future<void> _fetchProducts() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://dummyjson.com/products'); 
      setState(() {
        _produk = response.data['products']; 
        _isLoading = false; 
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts(); 
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _produk.length,
            itemBuilder: (context, index) {
              final product = _produk[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(
                    product['thumbnail'], 
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['title']), 
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product['description']), 
                      SizedBox(height: 4),
                      Text(
                        '\$${product['price']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProdukPage(
                          title: product['title'],
                          description: product['description'],
                          price: product['price'],
                          imageUrl: product['images'][0],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}

class DetailProdukPage extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  DetailProdukPage({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl, // Menampilkan gambar produk detail
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


