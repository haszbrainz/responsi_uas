import 'package:vania/vania.dart';

class CreateCleanTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('clean', () {
      primary('id_clean'); // Kolom id untuk primary key
      integer('id_clean', length: 11);
      string('jenis_sepatu', length: 100); // Jenis sepatu
      string('size', length: 5); // Ukuran sepatu
      string('warna', length: 20); // Warna sepatu
      string('email', length: 30); // Menyimpan email pelanggan

      // Menambahkan foreign key untuk relasi dengan tabel pelanggan (menggunakan email)
      foreign('email', 'pelanggan', 'email'); 
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('clean');
  }
}
