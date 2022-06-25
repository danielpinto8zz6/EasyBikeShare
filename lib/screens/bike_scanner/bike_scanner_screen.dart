import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:easybikeshare/screens/rental/rental_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BikeScannerScreen extends StatefulWidget {
  final RentalRepository rentalRepository;
  final TravelRepository travelRepository;
  final FCM firebaseMessaging;

  const BikeScannerScreen(
      {Key? key,
      required this.rentalRepository,
      required this.firebaseMessaging,
      required this.travelRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BikeScannerState();
}

class _BikeScannerState extends State<BikeScannerScreen> {
  String? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    facing: CameraFacing.back,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Scan bike code"),
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return Stack(
          children: [
            const Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: AssetImage('assets/images/qr-code.png'),
                  width: 75,
                  height: 75,
                )),
            Align(
              alignment: Alignment.center,
              child: FittedBox(
                  child: MobileScanner(
                      controller: controller,
                      fit: BoxFit.contain,
                      onDetect: (barcode, args) {
                        setState(() {
                          this.barcode = barcode.rawValue;
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RentalScreen(
                            bikeId: barcode.rawValue!,
                            rentalRepository: widget.rentalRepository,
                            travelRepository: widget.travelRepository,
                            firebaseMessaging: widget.firebaseMessaging,
                          ),
                        ));
                      })),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      color: Colors.black,
                      icon: ValueListenableBuilder(
                        valueListenable: controller.torchState,
                        builder: (context, state, child) {
                          switch (state as TorchState) {
                            case TorchState.off:
                              return const Icon(Icons.flash_off,
                                  color: Colors.grey);
                            case TorchState.on:
                              return const Icon(Icons.flash_on,
                                  color: Colors.black);
                          }
                        },
                      ),
                      iconSize: 32.0,
                      onPressed: () => controller.toggleTorch(),
                      padding: const EdgeInsets.all(50),
                    ),
                    IconButton(
                      color: Colors.black,
                      icon: ValueListenableBuilder(
                        valueListenable: controller.cameraFacingState,
                        builder: (context, state, child) {
                          switch (state as CameraFacing) {
                            case CameraFacing.front:
                              return const Icon(Icons.camera_front);
                            case CameraFacing.back:
                              return const Icon(Icons.camera_rear);
                          }
                        },
                      ),
                      iconSize: 32.0,
                      onPressed: () => controller.switchCamera(),
                      padding: const EdgeInsets.all(50),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
