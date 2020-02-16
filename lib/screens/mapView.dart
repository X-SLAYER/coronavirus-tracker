import 'dart:async';
import 'dart:convert';

import 'package:corona_tracker/Models/place.dart';
import 'package:corona_tracker/Models/report.dart';
import 'package:corona_tracker/provider/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapController _controller;
  StatefulMapController stfuMapController;
  List<Report> reports = List<Report>();
  List<Place> places = List<Place>();
  List<Marker> markers = List<Marker>();
  String recoverd, infected;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer _timer;

  @override
  void initState() {
    _controller = MapController();
    stfuMapController = StatefulMapController(mapController: _controller);
    stfuMapController.onReady.then(
      (_) {},
    );
    super.initState();
    track();
    doCheck();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  ///updated check
  doCheck() {
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      track();
    });
  }

  ///Getting info about virus updated every 10 seconds
  Future track() async {
    try {
      http.Response reponse =
          await http.get("https://coronavirus.app/get-latest");
      var decodedBody = json.decode(reponse.body);
      var decodedReports = decodedBody['reports'];
      var decodedPlaces = decodedBody['places'];

      getLists(decodedReports, decodedPlaces);
      fillReport();
      insertMarker();
    } catch (exc) {
      print(exc.toString());
    }
  }

  ///fill The list of places and reports
  getLists(dynamic decodedReports, dynamic decodedPlaces) {
    for (var item in decodedReports) {
      reports.add(Report.fromJson(item));
    }
    //---------
    for (var item in decodedPlaces) {
      places.add(Place.fromJson(item));
    }
  }

  ///insert each report to place
  fillReport() {
    places.forEach((place) => place.getReport(reports));
  }

  ///insert markers on map
  insertMarker() {
    markers.clear();
    places.forEach((place) {
      setState(() {
        markers.add(
          Marker(
              anchorPos: AnchorPos.align(AnchorAlign.top),
              point: LatLng(place.latitude, place.longitude),
              builder: (context) {
                return Tooltip(
                  message:
                      '${place.country}\n Infected : ${place.report.infected}\n Recovered :  ${place.report.recovered == null ? 0 : place.report.recovered}',
                  child: GestureDetector(
                    onTap: () {
                      SnackBar thisCnack =
                          SnackBar(content: Text(place.country));
                      _scaffoldKey.currentState.showSnackBar(thisCnack);
                    },
                    child: Container(
                      height: 25.0,
                      width: 25.0,
                      decoration: BoxDecoration(
                        color: Colors.pink[100].withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.pink[300]),
                      ),
                    ),
                  ),
                );
              }),
        );
      });
    });
    Provider.of<InfoNotifier>(context, listen: false).setPlaces(places);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.blue[100],
          child: Stack(
            children: <Widget>[
              Container(
                child: FlutterMap(
                  mapController: _controller,
                  options: MapOptions(
                    // interactive: false,
                    center: LatLng(28.148321, 73.77984),
                    zoom: 2.0,
                    onTap: (cordinate) {
                      print(cordinate);
                    },
                  ),
                  layers: [
                    stfuMapController.tileLayer,
                    TileLayerOptions(
                      urlTemplate:
                          "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(
                      markers: markers,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
