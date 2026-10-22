// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// part 'splash_event.dart';
// part 'splash_state.dart';
//
// class SplashBloc extends Bloc<SplashEvent, SplashState> {
//   SplashBloc() : super(SplashInitial()) {
//     on<SplashStarted>(_onSplashStarted);
//   }
//
//   Future<void> _onSplashStarted(
//       SplashStarted event,
//       Emitter<SplashState> emit,
//       ) async {
//     emit(SplashLoading());
//     await Future.delayed(const Duration(seconds: 2));
//     emit(SplashNavigateToLogin());
//   }
// }


import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/token_service.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final TokenService _tokenService;

  SplashBloc({TokenService? tokenService})
      : _tokenService = tokenService ?? TokenService.instance,
        super(SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
      SplashStarted event,
      Emitter<SplashState> emit,
      ) async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));

    final hasToken = await _tokenService.hasToken();
    debugPrint('SplashBloc: hasToken -> $hasToken');

    if (hasToken) {
      debugPrint('SplashBloc: user is logged in -> navigating to Home');
      emit(SplashNavigateToHome());
    } else {
      debugPrint('SplashBloc: no token found -> navigating to Login');
      emit(SplashNavigateToLogin());
    }
  }
}