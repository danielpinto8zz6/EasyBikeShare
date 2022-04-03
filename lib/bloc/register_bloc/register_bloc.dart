import 'package:easybikeshare/bloc/auth_bloc/auth.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  RegisterBloc({required this.userRepository, required this.authenticationBloc})
      : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());

      try {
        await userRepository.register(
          event.username,
          event.password,
        );

        authenticationBloc.add(Registered());
      } catch (error) {
        emit(RegisterFailure(error: error.toString()));
      }
    });
  }
}
