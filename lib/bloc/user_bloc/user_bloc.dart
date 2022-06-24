import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/credit_card.dart';
import 'package:easybikeshare/models/user.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        var result = await userRepository.getUser();

        emit(UserLoaded(result));
      } catch (error) {
        emit(UserLoadFailure(error: error.toString()));
      }
    });

    on<SaveCreditCard>((event, emit) async {
      emit(CreditCardSaving());

      try {
        var result = await userRepository.addCreditCard(event.creditCard);
        if (result) {
          emit(CreditCardSaveSuccess());
        } else {
          throw Exception("Error saving credit card");
        }
      } catch (error) {
        emit(CreditCardSaveFailure(error: error.toString()));
      }
    });

    on<RemoveCreditCard>((event, emit) async {
      try {
        var result =
            await userRepository.removeCreditCard(event.creditCardNumber);
        if (result) {
          emit(CreditCardRemoveSuccess());
        } else {
          throw Exception("Error removing credit card");
        }
      } catch (error) {
        emit(CreditCardRemoveFailure(error: error.toString()));
      }
    });
  }
}
