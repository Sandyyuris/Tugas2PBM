// File: lib/login_page.dart

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'produk_page.dart'; // Nanti ini akan kita buka komentarnya setelah membuat halaman produk

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false; // Untuk menampilkan efek loading saat proses API

  void _handleLogin() async {
    // Menampilkan loading
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    // Validasi sederhana agar tidak kosong
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan Password (NIM) tidak boleh kosong!')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Memanggil fungsi login dari api_service.dart
    // Karena Username & Password diisi dengan NIM yang sama, kita lempar salah satu saja
    bool isSuccess = await _apiService.login(username);

    // Mematikan loading
    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Berhasil!')),
      );
      // NANTI KITA TAMBAHKAN KODE UNTUK PINDAH HALAMAN DI SINI
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProductPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Gagal! Pastikan NIM benar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login Praktikum PBM'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 30),
              
              // TextField 1: Username
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username (NIM)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              
              // TextField 2: Password
              TextField(
                controller: _passwordController,
                obscureText: true, // Agar teks disamarkan menjadi titik-titik (password)
                decoration: const InputDecoration(
                  labelText: 'Password (NIM)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              
              // Button Login
              SizedBox(
                width: double.infinity, // Tombol melebar penuh
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 18, color: Colors.white),
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