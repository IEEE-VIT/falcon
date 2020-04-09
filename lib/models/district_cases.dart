// To parse this JSON data, do
//
//     final districtCases = districtCasesFromJson(jsonString);

import 'dart:convert';

List<DistrictCases> districtCasesFromJson(String str) => List<DistrictCases>.from(json.decode(str).map((x) => DistrictCases.fromJson(x)));

String districtCasesToJson(List<DistrictCases> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DistrictCases {
    String state;
    List<DistrictDatum> districtData;

    DistrictCases({
        this.state,
        this.districtData,
    });

    factory DistrictCases.fromJson(Map<String, dynamic> json) => DistrictCases(
        state: json["state"],
        districtData: List<DistrictDatum>.from(json["districtData"].map((x) => DistrictDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "state": state,
        "districtData": List<dynamic>.from(districtData.map((x) => x.toJson())),
    };
}

class DistrictDatum {
    String district;
    int confirmed;
    String lastupdatedtime;
    Delta delta;

    DistrictDatum({
        this.district,
        this.confirmed,
        this.lastupdatedtime,
        this.delta,
    });

    factory DistrictDatum.fromJson(Map<String, dynamic> json) => DistrictDatum(
        district: json["district"],
        confirmed: json["confirmed"],
        lastupdatedtime: json["lastupdatedtime"],
        delta: Delta.fromJson(json["delta"]),
    );

    Map<String, dynamic> toJson() => {
        "district": district,
        "confirmed": confirmed,
        "lastupdatedtime": lastupdatedtime,
        "delta": delta.toJson(),
    };
}

class Delta {
    int confirmed;

    Delta({
        this.confirmed,
    });

    factory Delta.fromJson(Map<String, dynamic> json) => Delta(
        confirmed: json["confirmed"],
    );

    Map<String, dynamic> toJson() => {
        "confirmed": confirmed,
    };
}
