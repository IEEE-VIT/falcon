import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
	dynamic initDatabase() async {
		final Future<Database> database=openDatabase(
				join(await getDatabasesPath(), 'coordinate_database.db'),
				onCreate: (db, version) {
					return db.execute(
							'CREATE TABLE coordinate(time VARCHAR(20), latitude NUMERIC(20), longitude NUMERIC(20))'
					);
				},
				version: 1,
		);
		return database;
	} 
}
