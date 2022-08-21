import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d21_sosial_media/auth_repository.dart';
import 'package:flutter_d21_sosial_media/bloc/login/login_event.dart';
import 'package:flutter_d21_sosial_media/bloc/login/login_state.dart';
import 'package:flutter_d21_sosial_media/bloc/login/login_status.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChangedEvent) {
      yield state.copyWith(username: event.username);
    }  if (event is LoginPasswordChangedEvent) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmittedEvent) {
      yield state.copyWith(status: FormSubmitting());

      try {
        await authRepository.login();
        yield state.copyWith(status: SubmittionSuccess());
      } on Exception catch (e) {
        // throw e;
        yield state.copyWith(status: SubmissionFailed(e));
      }
    }
  }
}
