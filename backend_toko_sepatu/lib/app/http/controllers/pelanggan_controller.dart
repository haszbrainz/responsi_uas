import 'package:vania/vania.dart';

class PelangganController extends Controller {
  Future<Response> index(Request request) async {
    Map? user = Auth().user();
    user?.remove('password');
    return Response.json(user);
  }
}

final PelangganController userController = PelangganController();
