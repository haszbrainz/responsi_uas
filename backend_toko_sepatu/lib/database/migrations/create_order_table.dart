import 'package:vania/vania.dart';

class CreateOrderTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('order', () {
      primary('order_num');
      integer('order_num', length: 11);
      string('name_sepatu', length: 100); // Nama sepatu
      decimal('price', precision: 10, scale: 2); // Harga sepatu
      string('size', length: 5); // Ukuran sepatu

      // Kolom email untuk relasi
      string('email', length: 30); // Kolom email untuk referensi ke pelanggan
      
      // Menambahkan foreign key yang menghubungkan ke tabel pelanggan berdasarkan email
      foreign('email', 'pelanggan', 'email'); // Relasi ke tabel pelanggan dengan kolom 'email'
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('order');
  }
}
