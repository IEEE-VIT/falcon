class Coordinate {

	final double latitude;
	final double longitude;
	final DateTime datetime;

	Coordinate({
		this.latitude,
		this.longitude,
		this.datetime
	});

factory	Coordinate.fromJson(Map<dynamic, dynamic> json) {
		return Coordinate(
				latitude: 0,
				longitude: 0,
				datetime: DateTime.now(),
		);
	}

Map<String, dynamic>toJson(){
		return <String, dynamic>{
			'latitude': latitude,
			'longitude': longitude,
			'datetime': datetime
		};
	}
}
