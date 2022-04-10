import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:flutter/widgets.dart';

class AccountScreen extends StatefulWidget {
  final UserRepository userRepository;

  const AccountScreen({Key? key, required this.userRepository})
      : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
