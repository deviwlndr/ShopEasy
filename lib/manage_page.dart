import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ManagePage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  final Dio dio = Dio();

  // Fetch products from API
  Future<void> _fetchProducts() async {
    try {
      final response = await dio.get('https://dummyjson.com/products');
      setState(() {
        _products = response.data['products'];
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Add a new product
  Future<void> _createProduct(String title, String description, double price, String imageUrl) async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/products/add',
        data: {
          "title": title,
          "description": description,
          "price": price,
          "images": [imageUrl], // Kirim URL gambar sebagai array
        },
      );
      setState(() {
        _products.add(response.data);
      });
    } catch (e) {
      print("Error creating product: $e");
    }
  }

  // Update an existing product
  Future<void> _updateProduct(int id, String title, String description, double price, String imageUrl) async {
    try {
      final response = await dio.put(
        'https://dummyjson.com/products/$id',
        data: {
          "title": title,
          "description": description,
          "price": price,
          "images": [imageUrl], // Kirim URL gambar untuk update
        },
      );
      setState(() {
        final index = _products.indexWhere((product) => product['id'] == id);
        if (index != -1) {
          _products[index] = response.data;
        }
      });
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  // Delete a product
  Future<void> _deleteProduct(int id) async {
    try {
      await dio.delete('https://dummyjson.com/products/$id');
      setState(() {
        _products.removeWhere((product) => product['id'] == id);
      });
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  // Show form dialog for create or update
  void _showFormDialog({int? id, String? title, String? description, double? price, String? imageUrl}) {
    final _titleController = TextEditingController(text: title ?? '');
    final _descriptionController = TextEditingController(text: description ?? '');
    final _priceController = TextEditingController(text: price?.toString() ?? '');
    final _imageController = TextEditingController(text: imageUrl ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? 'Create Product' : 'Update Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final title = _titleController.text;
              final description = _descriptionController.text;
              final price = double.tryParse(_priceController.text) ?? 0.0;
              final imageUrl = _imageController.text;

              if (id == null) {
                _createProduct(title, description, price, imageUrl);
              } else {
                _updateProduct(id, title, description, price, imageUrl);
              }

              Navigator.pop(context);
            },
            child: Text(id == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: product['images'] != null && product['images'].isNotEmpty
                        ? Image.network(
                            product['images'][0], // Tampilkan gambar pertama
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image_not_supported, size: 50),
                    title: Text(product['title']),
                    subtitle: Text(product['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showFormDialog(
                            id: product['id'],
                            title: product['title'],
                            description: product['description'],
                            price: product['price'].toDouble(),
                            imageUrl: product['images'] != null && product['images'].isNotEmpty
                                ? product['images'][0]
                                : '',
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(product['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
