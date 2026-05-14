import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'produk_model.dart';

class ApiService {
  final String baseUrl = 'https://task.itprojects.web.id';
  final storage = const FlutterSecureStorage(); // Penyimpanan token

  // Login dan simpan token
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['data']['token'];
        
        await storage.write(key: 'auth_token', value: token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Ambil token
  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  // Ambil data produk (butuh token)
  Future<List<Product>> getProducts() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List products = data['data']['products'];
        
        return products.map((e) => Product.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Tambah produk
  Future<bool> addProduct(String name, String price, String description) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Hapus produk (soft delete)
  Future<bool> deleteProduct(int id) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products/$id');
    
    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  // Submit tugas akhir
  Future<bool> submitTugas(String name, String price, String description, String githubUrl) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products/submit');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'github_url': githubUrl,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}