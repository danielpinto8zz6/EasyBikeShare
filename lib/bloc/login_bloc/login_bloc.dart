import 'package:easybikeshare/bloc/auth_bloc/auth.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.userRepository, required this.authenticationBloc})
      : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        final token = await userRepository.login(
          event.username,
          event.password,
        );

        authenticationBloc
            .add(LoggedIn(token: token, username: event.username));
        emit(LoginInitial());
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });
  }
}
