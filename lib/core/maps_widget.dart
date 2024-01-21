import 'package:data_soft/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/shared_widgets.dart';
import 'external_sharing.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key, this.lat, this.lng, this.location});
  final String? location;
  final dynamic lat;
  final dynamic lng;
  @override
  Widget build(BuildContext context) {
    final location = lat == null ? null : LatLng(lat, lng);
    return lat != null && lng != null
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(borderRadius: borderRadius),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: location!,
                initialZoom: 17,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(markers: [
                  Marker(
                      point: location,
                      child: imageSvg(src: "location_pin", size: 100),
                      height: 100,
                      width: 100)
                ])
              ],
            ),
          )
        : GestureDetector(
            onTap: () {
              if (this.location != null) {
                showlaunchUrl(location, msg: "Not found location");
              }
            },
            child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/map_logo.jpg"))),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: imageSvg(src: "location_pin", size: 100)),
          );
  }
}
