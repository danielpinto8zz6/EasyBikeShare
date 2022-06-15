import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/user.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      var username = await userRepository.getUsername();
      var result = await userRepository.getUserByUsername(username!);

      emit(UserLoaded(result));
    });
  }
}
