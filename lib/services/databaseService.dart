import 'dart:async';

import 'package:falcon_corona_app/models/coordinate.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
	Future<Database> initDatabase() async {
		print(await getDatabasesPath());
		final Future<Database> database=openDatabase(
				join(await getDatabasesPath(), 'coordinateDatabase.db'),
				onCreate: (Database db,int version) async {
					print('I am here!');
					 await db.execute(
							'CREATE TABLE coordinates(datetime TEXT, latitude NUMERIC, longitude NUMERIC)'
					);
					 print('Table created!');
				},
				version: 1,
		);
		print('Database initialized!');
		return database;
	}

	Future<void> insertCoordinate(Database database, Coordinate coordinate) async {
		await database.insert(
				'coordinates',
				coordinate.toJson(),
				conflictAlgorithm: ConflictAlgorithm.replace,
		);
		print('Coordinate Added!');
	}

	Future<dynamic> getAllCoordinates(Database database) async {
		final List<Map<String, dynamic>> coordinates=await database.query('coordinates');
		return List.generate(coordinates.length, (i) {
			return Coordinate(
					latitude: coordinates[i]['latitude'],
					longitude: coordinates[i]['longitude'],
					datetime: coordinates[i]['datetime']
			);
		});
	}

  Future<dynamic> getAllRawCoordinates(Database database) async {
		final List<Map<String, dynamic>> coordinates=await database.query('coordinates');
		return coordinates;
	}
}
