import 'package:hoover/datamodels/nearbydrivers.dart';

class FireHelper {
  static List<NearbyDrivers> nearbyDriversList = [];

  static void removeFromList(String key) {
    int index = nearbyDriversList.indexWhere((element) => element.key == key);
    nearbyDriversList.removeAt(index);
  }

  static void updateNearbyLocation(NearbyDrivers drivers) {
    int index =
        nearbyDriversList.indexWhere((element) => element.key == drivers.key);
    nearbyDriversList[index].longitude = drivers.longitude;
    nearbyDriversList[index].latitude = drivers.latitude;
  }
}
