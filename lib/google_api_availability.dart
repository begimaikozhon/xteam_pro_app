import 'package:google_api_availability/google_api_availability.dart';

void checkGooglePlayServicesAvailability() async {
  GooglePlayServicesAvailability availability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
  if (availability != GooglePlayServicesAvailability.success) {
    // Выполните какие-либо действия, если Google Play Services недоступны
  }
}
