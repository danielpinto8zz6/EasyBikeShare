import 'package:easybikeshare/bloc/user_bloc/user_bloc.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/screens/widgets/profile_widget.dart';
import 'package:easybikeshare/screens/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final UserRepository userRepository;

  const EditProfilePage({Key? key, required this.userRepository})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      return UserBloc(widget.userRepository)..add(const LoadUser());
    }, child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoaded) {
        return Container(
          margin: const EdgeInsets.all(50),
          child: Builder(
            builder: (context) => Scaffold(
              // appBar: buildAppBar(context),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                physics: const BouncingScrollPhysics(),
                children: [
                  ProfileWidget(
                    imagePath:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMx1itTXTXLB8p4ALTTL8mUPa9TFN_m9h5VQ&usqp=CAU',
                    isEdit: true,
                    onClicked: () async {},
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Full Name',
                    text: state.user.name ?? "",
                    onChanged: (name) {},
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Username',
                    text: state.user.username,
                    onChanged: (email) {},
                  )
                ],
              ),
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
}
