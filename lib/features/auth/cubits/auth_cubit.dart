import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_model.dart';
import '../auth_repository.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final AuthModel authModel;

  Authenticated({required this.authModel});
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    checkAuthStatus();
  }

  AuthRepository get authRepository => _authRepository;

  void checkAuthStatus() {
    //authDetails is map. keys are isLogin,userId,authProvider,jwtToken
    final authDetails = _authRepository.getLocalAuthDetails();
    print(authDetails);

    if (authDetails['isLogin'] != null && authDetails['isLogin'] == true) {
      emit(Authenticated(authModel: AuthModel.fromJson(authDetails)));
    } else {
      emit(Unauthenticated());
    }
  }

  void statusUpdateAuth(AuthModel authModel) {
    emit(Authenticated(authModel: authModel));
  }

  bool logInStatus() {
    if (state is Authenticated) {
      return true;
    } else {
      return false;
    }
  }

  int? getId() {
    if (state is Authenticated) {
      return (state as Authenticated).authModel.id!;
    }
    return null;
  }

  String getName() {
    if (state is Authenticated) {
      return (state as Authenticated).authModel.username!;
    }
    return "";
  }

  String getEmail() {
    if (state is Authenticated) {
      return (state as Authenticated).authModel.email!;
    }
    return "";
  }

  String getMobile() {
    if (state is Authenticated) {
      return (state as Authenticated).authModel.mobile!;
    }
    return "";
  }

  String getProfile() {
    if (state is Authenticated) {
      return (state as Authenticated).authModel.image!;
    }
    return "";
  }

  void signOut() {
    if (state is Authenticated) {
      _authRepository.signOut();
      emit(Unauthenticated());
    }
  }

  void updateDetails({required AuthModel authModel}) {
    emit(Authenticated(authModel: authModel));
  }
}
