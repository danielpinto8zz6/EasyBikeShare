import 'package:easybikeshare/bloc/near_by_docks_bloc/nearby_docks_bloc.dart';
import 'package:easybikeshare/bloc/near_by_docks_bloc/nearby_docks_event.dart';
import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/bike_repository.dart';
import 'package:easybikeshare/repositories/payment_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/token_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/screens/profile/profile_screen.dart';
import 'package:easybikeshare/screens/bike_scanner/bike_scanner_screen.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/screens/near_by_docks/near_by_docks_screen.dart';
import 'package:easybikeshare/screens/rental/rental_history_screen.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  final DockRepository dockRepository;
  final UserRepository userRepository;
  final TokenRepository tokenRepository;
  final BikeRepository bikeRepository;
  final RentalRepository rentalRepository;
  final PaymentRepository paymentRepository;
  final TravelRepository travelRepository;
  final FCM firebaseMessaging;

  const MainScreen(
      {Key? key,
      required this.dockRepository,
      required this.userRepository,
      required this.tokenRepository,
      required this.bikeRepository,
      required this.rentalRepository,
      required this.paymentRepository,
      required this.firebaseMessaging,
      required this.travelRepository})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Visibility(
            visible: _currentIndex == 0,
            child: SizedBox(
              height: 50.0,
              // width: 50.0,
              child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => BikeScannerScreen(
                            rentalRepository: widget.rentalRepository,
                            travelRepository: widget.travelRepository,
                            firebaseMessaging: widget.firebaseMessaging,
                            userRepository: widget.userRepository,
                            dockRepository: widget.dockRepository,
                          ),
                        ))
                        .then((value) => setState(() {
                              BlocProvider.of<NearbyDocksBloc>(context).add(
                                const GetNearByDocks(),
                              );
                            }));
                  },
                  label: const Text("Scan"),
                  icon: const Icon(Icons.document_scanner),
                  backgroundColor: primaryBlue),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: primaryBlue,
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.bike_scooter),
              title: const Text("Rentals"),
              selectedColor: primaryBlue,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: primaryBlue,
            ),
          ],
        ),
        body: _getDrawerItemWidget(_currentIndex));
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return NearByDocksScreen(
            dockRepository: widget.dockRepository,
            userRepository: widget.userRepository,
            tokenRepository: widget.tokenRepository,
            bikeRepository: widget.bikeRepository,
            rentalRepository: widget.rentalRepository,
            travelRepository: widget.travelRepository,
            firebaseMessaging: widget.firebaseMessaging);
      case 1:
        return RentalHistoryScreen(
            rentalRepository: widget.rentalRepository,
            paymentRepository: widget.paymentRepository,
            travelRepository: widget.travelRepository);
      case 2:
        return ProfileScreen(userRepository: widget.userRepository);
      default:
        return const Text("Error");
    }
  }
}
