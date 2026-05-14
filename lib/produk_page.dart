// File: lib/produk_page.dart

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'produk_model.dart';
import 'add_produk_page.dart';

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
    _fetchProducts(); // Memanggil data produk saat halaman pertama kali dibuka
  }

  // Fungsi untuk mengambil data dari server
  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    
    List<Product> products = await _apiService.getProducts();
    
    setState(() {
      _products = products;
      _isLoading = false;
    });
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
            onPressed: _fetchProducts, // Tombol untuk refresh data
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Tampilan loading
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
                        trailing: Text(
                          'Rp ${product.price}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
          // Menunggu hasil dari halaman AddProductPage
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );

          // Jika ada produk baru yang berhasil ditambah (result == true), refresh daftar produk
          if (result == true) {
            _fetchProducts();
          }
        },
      ),
    ); // Ini adalah penutup Scaffold yang sudah ada sebelumnya
  }
}