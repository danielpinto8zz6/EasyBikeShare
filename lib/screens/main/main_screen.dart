import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/bike_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/token_repository.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/screens/account/account_screen.dart';
import 'package:easybikeshare/screens/bike_scanner/bike_scanner_screen.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/screens/near_by_docks/near_by_docks_screen.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  final DockRepository dockRepository;
  final UserRepository userRepository;
  final TokenRepository tokenRepository;
  final BikeRepository bikeRepository;
  final RentalRepository rentalRepository;
  final FCM firebaseMessaging;

  const MainScreen(
      {Key? key,
      required this.dockRepository,
      required this.userRepository,
      required this.tokenRepository,
      required this.bikeRepository,
      required this.rentalRepository,
      required this.firebaseMessaging})
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
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BikeScannerScreen(
                  rentalRepository: widget.rentalRepository,
                  firebaseMessaging: widget.firebaseMessaging,
                ),
              ));
            },
            label: const Text("Scan"),
            icon: const Icon(Icons.document_scanner),
            backgroundColor: primaryBlue),
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
              icon: const Icon(Icons.search),
              title: const Text("Search"),
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
            firebaseMessaging: widget.firebaseMessaging);
      case 1:
        return const Text("Error");
      case 2:
        return AccountScreen(userRepository: widget.userRepository);
      default:
        return const Text("Error");
    }
  }
}
