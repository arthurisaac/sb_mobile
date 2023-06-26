import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_model.dart';
import '../auth_repository.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}
class SignIn extends SignInState {
  final AuthModel authModel;

  SignIn({required this.authModel});
}
class SignInProgress extends SignInState {
  SignInProgress();
}

class SignInSuccess extends SignInState {
  final AuthModel authModel;
  SignInSuccess(this.authModel);
}

class SignInFailure extends SignInState {
  final String errorMessage;
  SignInFailure(this.errorMessage);
}

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  SignInCubit(this._authRepository) : super(SignInInitial());

  void signInUser({
    // AuthModel? authModel,
    String? email,
    String? password,}) {
    //emitting signInProgress state
    emit(SignInProgress());
    //signIn user with given provider and also add user detials in api
    _authRepository
        .login(
      email: email,
      password: password,
    ).then((result) {
      //success
      emit(SignInSuccess(AuthModel.fromJson(result)));
    }).catchError((e) {
      //failure
      emit(SignInFailure(e.toString()));
    });
  }
}