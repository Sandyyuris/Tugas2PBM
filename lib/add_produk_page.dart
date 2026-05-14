// File: lib/add_product_page.dart

import 'package:flutter/material.dart';
import 'api_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;

  void _saveProduct() async {
    setState(() => _isLoading = true);

    String name = _nameController.text;
    String price = _priceController.text;
    String description = _descriptionController.text;

    // Validasi input tidak boleh kosong
    if (name.isEmpty || price.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi!')),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Memanggil fungsi addProduct dari ApiService
    bool isSuccess = await _apiService.addProduct(name, price, description);

    setState(() => _isLoading = false);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil disimpan ke draft!')),
      );
      // Kembali ke halaman Katalog Produk sambil mengirim sinyal "true" bahwa ada data baru
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan produk.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.add_box, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            
            // Input Nama Produk
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Input Harga
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number, // Keyboard khusus angka
              decoration: const InputDecoration(
                labelText: 'Harga (Rp)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Input Deskripsi
            TextField(
              controller: _descriptionController,
              maxLines: 3, // Agar kotak teks lebih besar
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SIMPAN DRAFT',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}