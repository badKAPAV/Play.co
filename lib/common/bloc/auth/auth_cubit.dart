import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musify/common/bloc/auth/auth_state.dart';
import 'package:musify/domain/entities/auth/user.dart';
import 'package:musify/data/sources/auth/auth_firebase_service.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

final sl = GetIt.instance;

class AuthCubit extends Cubit<AuthState> {
  final AuthFirebaseService _authService = sl<AuthFirebaseService>();
  StreamSubscription<UserEntity?>? _authStateSubscription;

  AuthCubit() : super(AuthInitial());

  void checkAuthState() {
    emit(AuthLoading());
    _authStateSubscription?.cancel();
    _authStateSubscription = _authService.authStateChanges().listen(
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
      onError: (error) {
        emit(AuthError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  // void setUser(UserEntity user) {
  //   emit(state.copyWith(user: user));
  // }

  // void clearUser() {
  //   emit(const AuthState());
  // }

  Future<void> signOut() async {
    try {
      final result = await _authService.signout();
      result.fold(
        (error) => emit(AuthError(error)),
        (_) => emit(Unauthenticated()),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
