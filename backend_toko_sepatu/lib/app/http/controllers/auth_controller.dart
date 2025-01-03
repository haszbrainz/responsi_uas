import 'dart:io';
import 'package:backend_toko_sepatu/app/models/Pelanggan.dart';
import 'package:vania/vania.dart';

class AuthController extends Controller {
  // Fungsi untuk registrasi pengguna baru
  Future<Response> register(Request request) async {
    // Validasi input dari pengguna
    request.validate({
      'name': 'required',
      'email': 'required|email',
      'password': 'required', // Hapus validasi confirmed untuk password
    }, {
      'name.required': 'Nama tidak boleh kosong.',
      'email.required': 'Email tidak boleh kosong.',
      'email.email': 'Email tidak valid.',
      'password.required': 'Password tidak boleh kosong.',
    });

    // Ambil input dari pengguna
    final name = request.input('name');
    final email = request.input('email');
    var password = request.input('password'); // Password tanpa hashing

    // Cek apakah email sudah terdaftar
    var pelanggan = await Pelanggan().query().where('email', '=', email).first();
    if (pelanggan != null) {
      return Response.json({'message': 'User sudah ada.'}, 409); // Conflict
    }

    // Simpan data pengguna ke database (termasuk password tanpa hashing)
    await Pelanggan().query().insert({
      'name': name,
      'email': email,
      'password': password, // Simpan password langsung
      'created_at': DateTime.now().toIso8601String(),
    });

    return Response.json({'message': 'Berhasil mendaftarkan user.'}, 201); // Created
  }

  // Fungsi untuk login pengguna
  Future<Response> login(Request request) async {
    // Validasi input dari pengguna
    request.validate({
      'email': 'required|email',
      'password': 'required', // Hapus validasi confirmed untuk password
    }, {
      'email.required': 'Email tidak boleh kosong.',
      'email.email': 'Email tidak valid.',
      'password.required': 'Password tidak boleh kosong.',
    });

    // Ambil input dari pengguna
    final email = request.input('email');
    var password = request.input('password').toString();

    // Cari pengguna berdasarkan email
    var pelanggan = await Pelanggan().query().where('email', '=', email).first();
    if (pelanggan == null) {
      return Response.json(
          {'message': 'User belum terdaftar.'}, HttpStatus.unauthorized); // Unauthorized
    }

    // Verifikasi password tanpa hashing (langsung dibandingkan)
    if (password != pelanggan['password']) {
      return Response.json({
        'message': 'Password yang anda masukkan salah.',
      }, HttpStatus.unauthorized); // Unauthorized
    }

    // Jika login berhasil, buat token
    final token = await Auth()
        .login(pelanggan)
        .createToken(expiresIn: Duration(days: 30), withRefreshToken: true);

    return Response.json({
      'message': 'Berhasil login.',
      "token": token,
    }, 201); // Created
  }

  // Fungsi untuk memperbarui username pengguna
  Future<Response> updateUsername(Request request) async {
    // Validasi input username
    request.validate({
      'username': 'required|min_length:3',
    }, {
      'username.required': 'Username tidak boleh kosong.',
      'username.min_length': 'Username harus memiliki minimal 3 karakter.',
    });

    final username = request.input('username');

    // Verifikasi token dan dapatkan user saat ini
    final currentUser = await Auth().user();
    if (currentUser == null) {
      return Response.json({
        'message': 'User tidak ditemukan atau tidak valid.',
      }, HttpStatus.unauthorized); // Unauthorized
    }

    // Perbarui kolom 'name' di tabel pelanggan
    await Pelanggan().query().where('id', '=', currentUser['id']).update({
      'name': username, // Menggunakan kolom 'name' untuk menyimpan username
      'updated_at': DateTime.now().toIso8601String(),
    });

    return Response.json({'message': 'Username berhasil diperbarui.'}, 200); // OK
  }
}

// Membuat objek AuthController
final AuthController authController = AuthController();
