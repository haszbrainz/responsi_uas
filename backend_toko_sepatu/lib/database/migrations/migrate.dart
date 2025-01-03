import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_pelanggan_table.dart';
import 'create_clean_table.dart';
// import 'create_order_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateUserTable().up();
		 await CreatePelangganTable().up();
		 await CreateCleanTable().up();
		//  await CreateOrderTable().up();
	}

  dropTables() async {
		//  await CreateOrderTable().down();
		 await CreateCleanTable().down();
		 await CreatePelangganTable().down();
		 await CreateUserTable().down();
	 }
}
