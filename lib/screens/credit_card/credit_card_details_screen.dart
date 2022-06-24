import 'dart:async';

import 'package:easybikeshare/bloc/user_bloc/user_bloc.dart';
import 'package:easybikeshare/models/credit_card.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreditCardDetailsScreen extends StatefulWidget {
  final CreditCard creditCard;
  final UserRepository userRepository;

  const CreditCardDetailsScreen(
      {Key? key, required this.creditCard, required this.userRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreditCardDetailsState();
}

class _CreditCardDetailsState extends State<CreditCardDetailsScreen> {
  bool isCvvFocused = false;
  final _removeButtonController = RoundedLoadingButtonController();
  late final UserBloc userBloc;

  _onRemoveButtonPressed() {
    _removeButtonController.reset();
    _removeButtonController.start();
    userBloc.add(RemoveCreditCard(widget.creditCard.cardNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text("Credit card"),
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: BlocProvider(
            create: (context) {
              userBloc = UserBloc(widget.userRepository);
              return userBloc;
            },
            child: BlocListener<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is CreditCardRemoveFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to remove credit card."),
                        backgroundColor: Colors.red,
                      ),
                    );

                    _removeButtonController.error();

                    Timer(const Duration(seconds: 3), () {
                      _removeButtonController.reset();
                    });
                  }

                  if (state is CreditCardRemoveSuccess) {
                    _removeButtonController.success();
                    Navigator.of(context).pop();
                  }
                },
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      CreditCardWidget(
                        cardBgColor: primaryBlue,
                        cardNumber: widget.creditCard.cardNumber,
                        expiryDate: widget.creditCard.expiryDate,
                        cardHolderName: widget.creditCard.cardHolderName,
                        cvvCode: widget.creditCard.cvvCode,
                        showBackView: isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        onCreditCardWidgetChange: (brand) {},
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin: const EdgeInsets.only(
                              left: 16, top: 16, right: 16),
                          child: RoundedLoadingButton(
                            color: Colors.red,
                            controller: _removeButtonController,
                            animateOnTap: false,
                            onPressed: () => _onRemoveButtonPressed(),
                            elevation: 0,
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            borderRadius: 14.0,
                            child: Text('Remove',
                                style: heading5.copyWith(color: Colors.white)),
                          ))
                    ],
                  ),
                ))));
  }
}
