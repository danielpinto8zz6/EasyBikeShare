import 'package:easybikeshare/bloc/user_bloc/user_bloc.dart';
import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/repositories/feedback_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/screens/credit_card/credit_card_screen.dart';
import 'package:easybikeshare/screens/rental/rental_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BikeScannerScreen extends StatefulWidget {
  final RentalRepository rentalRepository;
  final TravelRepository travelRepository;
  final UserRepository userRepository;
  final DockRepository dockRepository;
  final FeedbackRepository feedbackRepository;

  final FCM firebaseMessaging;

  const BikeScannerScreen(
      {Key? key,
      required this.rentalRepository,
      required this.firebaseMessaging,
      required this.travelRepository,
      required this.userRepository,
      required this.dockRepository,
      required this.feedbackRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BikeScannerState();
}

class _BikeScannerState extends State<BikeScannerScreen> {
  String? barcode;
  late final UserBloc bloc;

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
            onPressed: () => Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            }),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("Scan bike code"),
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: BlocProvider(create: (context) {
          bloc = UserBloc(widget.userRepository)..add(GetCreditCards());
          return bloc;
        }, child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          if (state is CreditCardsLoaded && state.creditCards.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CreditCardScreen(
                  userRepository: widget.userRepository,
                ),
              ));
            });
          } else if (state is CreditCardsLoaded &&
              state.creditCards.isNotEmpty) {
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
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RentalScreen(
                                          bikeId: barcode.rawValue!,
                                          rentalRepository:
                                              widget.rentalRepository,
                                          travelRepository:
                                              widget.travelRepository,
                                          firebaseMessaging:
                                              widget.firebaseMessaging,
                                          dockRepository: widget.dockRepository,
                                          feedbackRepository:
                                              widget.feedbackRepository,
                                        )),
                                (Route<dynamic> route) => route.isFirst);
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
          }

          return Container(
              height: 500,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[CircularProgressIndicator()],
                ),
              ));
        })));
  }
}
