import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'auth.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationUninitialized()) {
    on<AppStarted>((event, emit) async {
      var token = await userRepository.getToken();
      var username = await userRepository.getUsername();

      var isValid = token != null && username != null;

      if (isValid) {
        emit(AuthenticationAuthenticated(username: username, token: token));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationLoading());
      await userRepository.persistToken(event.token);
      await userRepository.persistUsername(event.username);
      emit(AuthenticationAuthenticated(
          username: event.username, token: event.token));
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthenticationLoading());
      await userRepository.deleteToken();
      await userRepository.deleteUsername();
      emit(AuthenticationUnauthenticated());
    });

    on<Register>((event, emit) => emit(Registering()));

    on<Login>((event, emit) => emit(LogingIn()));
  }
}
