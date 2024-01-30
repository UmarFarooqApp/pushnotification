import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:local_services/utils/extra_functions.dart';

class LocationController extends GetxController implements GetxService {
  late Position currentPosition;
  RxString cityName = "".obs;
  Future<bool> getCurrentPosition() async {
    try {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) {
        return false;
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        currentPosition = position;
        cityName.value = placemarks[0].locality.toString().toLowerCase();
        update();
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
