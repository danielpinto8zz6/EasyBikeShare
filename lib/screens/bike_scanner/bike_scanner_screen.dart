import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/screens/rental/rental_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BikeScannerScreen extends StatefulWidget {
  final RentalRepository rentalRepository;

  const BikeScannerScreen({Key? key, required this.rentalRepository})
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (context) {
        return Stack(
          children: [
            MobileScanner(
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
                    ),
                  ));
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 100,
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: ValueListenableBuilder(
                        valueListenable: controller.torchState,
                        builder: (context, state, child) {
                          switch (state as TorchState) {
                            case TorchState.off:
                              return const Icon(Icons.flash_off,
                                  color: Colors.grey);
                            case TorchState.on:
                              return const Icon(Icons.flash_on,
                                  color: Colors.yellow);
                          }
                        },
                      ),
                      iconSize: 32.0,
                      onPressed: () => controller.toggleTorch(),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 200,
                        height: 50,
                        child: FittedBox(
                          child: Text(
                            barcode ?? 'Scan something!',
                            overflow: TextOverflow.fade,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
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
