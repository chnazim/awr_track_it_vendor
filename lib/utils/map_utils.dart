import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(double latitude, double longitude) async {
  final googleMapsUrl =
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
  final appleMapsUrl = 'https://maps.apple.com/?daddr=$latitude,$longitude';

  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
  } else if (await canLaunch(appleMapsUrl)) {
    await launch(appleMapsUrl);
  } else {
    throw 'Could not open map.';
  }
}
