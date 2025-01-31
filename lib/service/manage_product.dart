import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// ProductCard widget untuk menampilkan detail produk
class ProductCard extends StatelessWidget {
  final dynamic product; // Produk yang diambil dari API
  final Function onEdit;
  final Function onDelete;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            // Product Image
            product['images'] != null && product['images'].isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product['images'][0],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.image_not_supported, size: 80),
            
            const SizedBox(width: 15),
            
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product['description'],
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            // Edit and Delete Buttons
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEdit(),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ManagePage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  final Dio dio = Dio();
  final String _baseUrl = 'https://dummyjson.com';

  // Fetch products from API
  Future<void> _fetchProducts() async {
    try {
      final response = await dio.get('$_baseUrl/products');
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
              _updateProduct(id, title, description, price, imageUrl); // Update Product
            }

            Navigator.pop(context);
          },
          child: Text(id == null ? 'Create' : 'Update'),
        ),
      ],
    ),
  );
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
      // Add the newly created product to the top of the list
      _products.insert(0, response.data);
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
        _products[index] = response.data; // Update the product in the list
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
                return ProductCard(
                  product: product,
                  onEdit: () => _showFormDialog(
                    id: product['id'],
                    title: product['title'],
                    description: product['description'],
                    price: product['price'].toDouble(),
                    imageUrl: product['images'] != null && product['images'].isNotEmpty
                        ? product['images'][0]
                        : '',
                  ),
                  onDelete: () => _deleteProduct(product['id']),
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