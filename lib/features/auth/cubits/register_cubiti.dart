import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_model.dart';
import '../auth_repository.dart';
@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}
class SignUp extends SignUpState {
  //to store authDetials
  final AuthModel authModel;

  SignUp({required this.authModel});
}

class SignUpProgress extends SignUpState {
  SignUpProgress();
}

class SignUpSuccess extends SignUpState {
  final AuthModel authModel;

  SignUpSuccess({required this.authModel});
}

class SignUpFailure extends SignUpState {
  final String errorMessage;
  SignUpFailure(this.errorMessage);
}

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;
  SignUpCubit(this._authRepository) : super(SignUpInitial());

  //to signIn user
  void signUpUser({
    String? nom,
    String? prenom,
    String? email,
    //String? mobile,
    String? password,
    String? passwordConfirmation,
    String? mobile,
    //String? fcmId,
    //String? latitude,
    //String? longitude
  }) {
    //emitting signInProgress state
    //  emit(SignInProgress(authProvider));
    //signIn user with given provider and also add user details in api
    _authRepository.addUserData(
      nom: nom,
      prenom: prenom,
      email: email,
      //mobile: mobile,
      password: password,
      passwordConfirmation: passwordConfirmation,
      mobile: mobile,
      //latitude: latitude ?? "",
      //longitude: longitude ?? ""
    ).then((result) {
      //success
      emit(SignUpSuccess(authModel: AuthModel.fromJson(result)));
    }).catchError((e) {
      //failure

      print("failure");
      print(e);
      emit(SignUpFailure(e.toString()));
    });
  }

}