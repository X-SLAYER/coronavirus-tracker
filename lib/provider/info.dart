import 'package:corona_tracker/Models/place.dart';
import 'package:flutter/material.dart';

class InfoNotifier extends ChangeNotifier {
  List<Place> places = List<Place>();

  setPlaces(places) {
    this.places = places;
    notifyListeners();
  }

  List<Place> getPlaces() {
    return places;
  }
}
