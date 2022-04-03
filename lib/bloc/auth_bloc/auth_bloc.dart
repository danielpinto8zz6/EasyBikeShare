import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'auth.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationUninitialized()) {
    on<AppStarted>((event, emit) async {
      final bool hasToken = await userRepository.hasToken();
      if (hasToken) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationLoading());
      await userRepository.persistToken(event.token);
      await userRepository.persistUsername(event.username);
      emit(AuthenticationAuthenticated());
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthenticationLoading());
      await userRepository.deleteToken();
      await userRepository.deleteUsername();
      emit(AuthenticationUnauthenticated());
    });

    on<RedirectedToRegister>((event, emit) async {
      emit(RedirectingToRegister());
    });

    on<RedirectedToLogin>((event, emit) async {
      emit(RedirectingToLogin());
    });

    on<Registered>((event, emit) async {
      emit(RedirectingToLogin());
    });
  }
}
