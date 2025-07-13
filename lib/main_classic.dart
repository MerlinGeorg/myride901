import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myride901/main.dart' as entry;
import 'package:myride901/flavor_config.dart';

Future main() async {
  bool isRelease = false;

  try {
    await dotenv.load();
    isRelease = dotenv.env['IS_RELEASE'] == 'true' ? true : false;
  } catch (e) {
    print("IS_RELEASE missing in .env");
  }

  FlavorConfig(
    flavor: Flavor.CLASSIC,
    values: FlavorValues(
      features: {
        "vehicle_details_pdf_download": false,
      },
      apiUrl: isRelease
          ? "https://api.myride901.com/web/api"
          : "https://api.myride901.com/dev/api",
      // : "https://4077-2001-56a-7859-2c00-16c-c65d-a95e-dc33.ngrok-free.app/api", // local
      showBanner: isRelease ? false : true,
    ),
  );
  entry.main();
}
