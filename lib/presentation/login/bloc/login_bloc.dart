import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/token_service.dart';

import '../data/repositories/auth_repository.dart';
import '../models/login_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final TokenService _tokenService;

  LoginBloc({
    AuthRepository? authRepository,
    TokenService? tokenService,
  })  : _authRepository = authRepository ?? AuthRepository(),
        _tokenService = tokenService ?? TokenService.instance,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, errorMessage: null));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event,
      Emitter<LoginState> emit,
      ) {
    emit(state.copyWith(password: event.password, errorMessage: null));
  }

  Future<void> _onSubmitted(
      LoginSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(errorMessage: 'Email and password are required'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    debugPrint('LoginBloc: submitting login for ${state.email}');

    try {
      final LoginResponseModel response = await _authRepository.login(
        email: state.email,
        password: state.password,
      );

      debugPrint('LoginBloc: login success');
      debugPrint('LoginBloc: access=${response.access}');
      debugPrint('LoginBloc: refresh=${response.refresh}');

      await _tokenService.saveTokens(
        accessToken: response.access,
        refreshToken: response.refresh,
      );
      debugPrint('LoginBloc: tokens saved via TokenService');

      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          accessToken: response.access,
          refreshToken: response.refresh,
        ),
      );
    } catch (e) {
      debugPrint('LoginBloc: login failed -> $e');
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Login failed. Please check your credentials.',
        ),
      );
    }
  }
}