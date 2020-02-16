class Report {
  String id;
  String createdAt;
  bool hide;
  int infected;
  String placeId;
  int recovered;
  String date;

  Report(this.id, this.createdAt, this.hide, this.infected, this.placeId,
      this.recovered, this.date);

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    hide = json['hide'];
    infected = json['infected'];
    placeId = json['placeId'];
    recovered = json['recovered'];
    date = json['date'];
  }
}
