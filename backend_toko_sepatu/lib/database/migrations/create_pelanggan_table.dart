import 'package:vania/vania.dart';

class CreatePelangganTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('pelanggan', () {
      id(); // Menambahkan kolom id sebagai primary key
      string('name', length: 15); // Nama pelanggan
      string('email', length: 30, unique: true); // Email pelanggan
      string('password', length: 20); // Password pelanggan
      string('address', length: 255); // Alamat lengkap pelanggan
      string('phone', length: 20); // Nomor telepon pelanggan
      dateTime('created_at', nullable: true);
      dateTime('updated_at', nullable: true);
      dateTime('deleted_at', nullable: true); // Waktu penghapusan
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('pelanggan');
  }
}