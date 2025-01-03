import 'package:vania/vania.dart';
import 'package:backend_toko_sepatu/app/models/clean.dart';

class CleanController extends Controller {
  // Menampilkan semua booking cuci sepatu
  Future<Response> index() async {
    final cleanBookings = await Clean().query().get();
    return Response.json({'data': cleanBookings});
  }

  // Menambahkan booking cuci sepatu baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'jenis_sepatu': 'required|string|max_length:100',
        'size': 'required|string|max_length:5',
        'warna': 'required|string|max_length:20',
        'email': 'required|email',
      });

      final cleanData = request.input();
      cleanData['created_at'] = DateTime.now().toIso8601String();

      // Insert data ke tabel clean
      final cleanBooking = await Clean().query().insert(cleanData);

      return Response.json({
        'message': 'Booking cuci sepatu berhasil ditambahkan.',
        'data': cleanBooking,
      }, 201); // 201 Created
    } catch (e) {
      return Response.json({'message': 'Terjadi kesalahan di sisi server.'}, 500);
    }
  }

  // Mendapatkan detail booking cuci sepatu berdasarkan ID
  Future<Response> show(int id) async {
    final cleanBooking = await Clean().query().where('id_clean', '=', id).first();

    if (cleanBooking == null) {
      return Response.json({'message': 'Booking cuci sepatu tidak ditemukan.'}, 404); // 404 Not Found
    }

    return Response.json({'data': cleanBooking});
  }

  // Mengupdate booking cuci sepatu
  Future<Response> update(Request request, int id) async {
    try {
      // Validasi input
      request.validate({
        'jenis_sepatu': 'required|string|max_length:100',
        'size': 'required|string|max_length:5',
        'warna': 'required|string|max_length:20',
        'email': 'required|email',
      });

      final updatedData = request.input();
      updatedData['updated_at'] = DateTime.now().toIso8601String();

      // Update data booking
      final updatedBooking = await Clean().query().where('id_clean', '=', id).update(updatedData);

      if (updatedBooking == 0) {
        return Response.json({'message': 'Booking cuci sepatu tidak ditemukan.'}, 404); // 404 Not Found
      }

      return Response.json({'message': 'Booking cuci sepatu berhasil diperbarui.'}, 200); // 200 OK
    } catch (e) {
      return Response.json({'message': 'Terjadi kesalahan di sisi server.'}, 500); // 500 Server Error
    }
  }

  // Menghapus booking cuci sepatu
  Future<Response> destroy(int id) async {
    try {
      final deletedBooking = await Clean().query().where('id_clean', '=', id).delete();

      if (deletedBooking == 0) {
        return Response.json({'message': 'Booking cuci sepatu tidak ditemukan.'}, 404); // 404 Not Found
      }

      return Response.json({'message': 'Booking cuci sepatu berhasil dihapus.'}, 200); // 200 OK
    } catch (e) {
      return Response.json({'message': 'Terjadi kesalahan di sisi server.'}, 500); // 500 Server Error
    }
  }
}

// Membuat objek CleanController
final CleanController cleanController = CleanController();
