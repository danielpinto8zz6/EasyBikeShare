import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:easybikeshare/bloc/user_bloc/user_bloc.dart';
import 'package:easybikeshare/models/credit_card.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreditCardScreen extends StatefulWidget {
  final UserRepository userRepository;

  const CreditCardScreen({Key? key, required this.userRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCardScreen> {
  CreditCard creditCard = CreditCard('', '', '', '');
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _saveButtonController = RoundedLoadingButtonController();
  late final UserBloc userBloc;

  _onSaveButtonPressed() {
    _saveButtonController.reset();
    _saveButtonController.start();
    if (formKey.currentState!.validate()) {
      userBloc.add(SaveCreditCard(creditCard));
    } else {
      _saveButtonController.error();
      Timer(const Duration(seconds: 3), () {
        _saveButtonController.reset();
      });
    }
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
                  if (state is CreditCardSaveFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to save credit card."),
                        backgroundColor: Colors.red,
                      ),
                    );

                    _saveButtonController.error();

                    Timer(const Duration(seconds: 3), () {
                      _saveButtonController.reset();
                    });
                  }

                  if (state is CreditCardSaveSuccess) {
                    _saveButtonController.success();
                    Navigator.of(context).pop();
                  }
                },
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      CreditCardWidget(
                        cardBgColor: primaryBlue,
                        cardNumber: creditCard.cardNumber,
                        expiryDate: creditCard.expiryDate,
                        cardHolderName: creditCard.cardHolderName,
                        cvvCode: creditCard.cvvCode,
                        showBackView: isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        onCreditCardWidgetChange: (brand) {},
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CreditCardForm(
                                  formKey: formKey,
                                  onCreditCardModelChange:
                                      onCreditCardModelChange,
                                  obscureCvv: true,
                                  obscureNumber: true,
                                  cardNumberDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Number',
                                    hintText: 'XXXX XXXX XXXX XXXX',
                                  ),
                                  expiryDateDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Expired Date',
                                    hintText: 'XX/XX',
                                  ),
                                  cvvCodeDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'CVV',
                                    hintText: 'XXX',
                                  ),
                                  cardHolderDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Card Holder Name',
                                  ),
                                  cardHolderName: creditCard.cardHolderName,
                                  cardNumber: creditCard.cardNumber,
                                  cvvCode: creditCard.cvvCode,
                                  expiryDate: creditCard.expiryDate,
                                  themeColor: primaryBlue),
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  margin: const EdgeInsets.only(
                                      left: 16, top: 16, right: 16),
                                  child: RoundedLoadingButton(
                                    color: primaryBlue,
                                    controller: _saveButtonController,
                                    animateOnTap: false,
                                    onPressed: () => _onSaveButtonPressed(),
                                    elevation: 0,
                                    height: 56,
                                    width: MediaQuery.of(context).size.width,
                                    borderRadius: 14.0,
                                    child: Text('Save',
                                        style: heading5.copyWith(
                                            color: Colors.white)),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      creditCard.cardNumber = creditCardModel.cardNumber;
      creditCard.expiryDate = creditCardModel.expiryDate;
      creditCard.cardHolderName = creditCardModel.cardHolderName;
      creditCard.cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
