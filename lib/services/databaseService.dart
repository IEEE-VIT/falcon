import 'dart:async';

import 'package:falcon_corona_app/models/coordinate.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
	Future<Database> initDatabase() async {
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

	Future<void> insertCoordinate(Database database, Coordinate coordinate) async {
		await database.insert(
				'coordinate_database',
				coordinate.toJson(),
				conflictAlgorithm: ConflictAlgorithm.replace,
		);
	}

	Future<List<Coordinate>> getAllCoordinates(Database database) async {}
}
