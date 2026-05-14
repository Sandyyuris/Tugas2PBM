import 'package:flutter/material.dart';
import 'api_service.dart';
import 'produk_model.dart';
import 'add_produk_page.dart';
import 'submit_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    List<Product> products = await _apiService.getProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  // Konfirmasi sebelum hapus (soft delete)
  void _confirmDelete(BuildContext context, int productId, String productName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: Text('Yakin ingin menghapus "$productName"?\n\nData hanya akan disembunyikan dari layarmu (Soft Delete).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              
              setState(() => _isLoading = true);
              
              bool isSuccess = await _apiService.deleteProduct(productId);
              
              if (isSuccess) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produk berhasil dihapus!'), backgroundColor: Colors.green),
                  );
                }
                _fetchProducts(); // Refresh data
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menghapus produk!'), backgroundColor: Colors.red),
                  );
                  setState(() => _isLoading = false);
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: _fetchProducts,
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Kumpulkan Tugas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubmitPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('Belum ada produk. Silakan tambah data.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.inventory, color: Colors.white),
                        ),
                        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(product.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${product.price}',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                if (product.id != null) {
                                  _confirmDelete(context, product.id!, product.name);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
          if (result == true) {
            _fetchProducts();
          }
        },
      ),
    );
  }
}