import 'dart:async';

import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/repositories/token_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final eventCtlr = StreamController<String>.broadcast();

  final UserRepository userRepository;
  final TokenRepository tokenRepository;

  FCM({required this.userRepository, required this.tokenRepository});

  setNotifications() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(
      (message) async {
        streamCtlr.sink.add("message received");
        if (message.data.containsKey('event')) {
          eventCtlr.sink.add(message.data["event"]);
        }

        if (message.notification?.body != null) {
          Fluttertoast.showToast(
              msg: message.notification!.body!, gravity: ToastGravity.TOP);
        }
      },
    );
  }

  setToken(username) {
    // With this token you can test it easily on your phone
    _firebaseMessaging
        .getToken()
        .then((token) => tokenRepository.setToken(username!, token!));
  }

  dispose() {
    streamCtlr.close();
  }
}
