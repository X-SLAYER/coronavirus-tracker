import 'package:corona_tracker/Models/report.dart';

class Place {
  String id;
  String createdAt;
  double latitude;
  double longitude;
  String country;
  String name;
  Report report;

  Place(this.id, this.createdAt, this.latitude, this.longitude, this.country,
      this.name);

  Place.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    country = json['country'];
    name = json['name'];
  }
  getReport(List<Report> report) {
    report.forEach((v) {
      if (v.placeId == id) {
        this.report = v;
      }
    });
  }
}
