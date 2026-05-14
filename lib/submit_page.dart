import 'package:flutter/material.dart';
import 'api_service.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _githubController = TextEditingController(); 
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;

  void _submitFinalTask() async {
    setState(() => _isLoading = true);

    String name = _nameController.text;
    String price = _priceController.text;
    String description = _descriptionController.text;
    String githubUrl = _githubController.text;

    // Validasi input
    if (name.isEmpty || price.isEmpty || description.isEmpty || githubUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom wajib diisi termasuk Link GitHub!'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    bool isSuccess = await _apiService.submitTugas(name, price, description, githubUrl);

    setState(() => _isLoading = false);

    if (isSuccess) {
      if (context.mounted) {
        // Dialog sukses
        showDialog(
          context: context,
          barrierDismissible: false, 
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Sukses Submit!'),
              ],
            ),
            content: const Text(
              'Tugas akhir berhasil dikirim ke server.\n\nPastikan repository GitHub kamu sudah di-set ke PUBLIC agar bisa diperiksa oleh asisten praktikum.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengirim tugas. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kumpulkan Tugas Akhir'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.green),
              const SizedBox(height: 12),
              const Text(
                'FORM PENGUMPULAN AKHIR',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 4),
              const Text(
                'Peringatan: Data yang sudah dikirim tidak dapat diubah!',
                style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk Final',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Final (Rp)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Produk',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _githubController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Link Repository GitHub', 
                  hintText: 'https://github.com/username/repo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
              ),
              const SizedBox(height: 28),
              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitFinalTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'SUBMIT TUGAS SEKARANG',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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