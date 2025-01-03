import 'package:vania/vania.dart';
import 'package:backend_toko_sepatu/app/http/controllers/auth_controller.dart';
import 'package:backend_toko_sepatu/app/http/controllers/pelanggan_controller.dart'; // Pastikan sudah ada
import 'package:backend_toko_sepatu/app/http/middleware/authenticate.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base Route Prefix
    // Router.basePrefix('api'); // Menggunakan prefix 'api' untuk semua rute

      Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
      Router.put('update', authController.updateUsername); // Menggunakan PUT
    }, prefix: 'auth');
    // Rute untuk mendapatkan data pelanggan yang sedang login
   Router.group(() {
      Router.get('me', userController.index);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);
    // CRUD Rute untuk pelanggan
    // Router.post("/pelanggan", pelangganController.create); // Create pelanggan
    // Router.get("/pelanggan", pelangganController.index); // Get all pelanggan
    // Router.get("/pelanggan/{id}", pelangganController.show);  // Get pelanggan by id
    // Router.put("/pelanggan/{id}", pelangganController.update); // Update pelanggan
    // Router.delete("/pelanggan/{id}", pelangganController.delete); // Delete pelanggan
  }
}
