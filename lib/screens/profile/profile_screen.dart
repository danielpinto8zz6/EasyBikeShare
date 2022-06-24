import 'package:easybikeshare/bloc/user_bloc/user_bloc.dart';
import 'package:easybikeshare/models/user.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/screens/credit_card/credit_card_details_screen.dart';
import 'package:easybikeshare/screens/credit_card/credit_card_screen.dart';
import 'package:easybikeshare/screens/profile/edit_profile_screen.dart';
import 'package:easybikeshare/screens/widgets/profile_widget.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final UserRepository userRepository;

  const ProfileScreen({Key? key, required this.userRepository})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      return UserBloc(widget.userRepository)..add(const LoadUser());
    }, child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoaded) {
        return Builder(
          builder: (context) => Scaffold(
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 48),
                ProfileWidget(
                  imagePath:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMx1itTXTXLB8p4ALTTL8mUPa9TFN_m9h5VQ&usqp=CAU',
                  onClicked: () {},
                ),
                const SizedBox(height: 24),
                buildName(state.user),
                const SizedBox(height: 48),
                Column(
                  children: state.user.creditCards
                      .map<Widget>(
                        (v) => ListTile(
                            leading:
                                const Icon(Icons.payment, color: Colors.black),
                            title: Text(v.cardNumber.toString()),
                            textColor: Colors.black,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreditCardDetailsScreen(
                                      creditCard: v,
                                      userRepository: widget.userRepository),
                                )).then((value) => setState(() {
                                  BlocProvider.of<UserBloc>(context).add(
                                    const LoadUser(),
                                  );
                                }))),
                      )
                      .toList(),
                ),
                ListTile(
                    leading: const Icon(Icons.add, color: Colors.black),
                    title: const Text('Add credit card'),
                    textColor: Colors.black,
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreditCardScreen(
                                userRepository: widget.userRepository),
                          ),
                        ).then((value) => setState(() {
                              BlocProvider.of<UserBloc>(context).add(
                                const LoadUser(),
                              );
                            }))),
              ],
            ),
          ),
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
    }));
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name ?? user.username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.username,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildEditProfileButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primaryBlue,
          onPrimary: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: const Text('Edit profile'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  EditProfilePage(userRepository: widget.userRepository)),
        ),
      );
}
