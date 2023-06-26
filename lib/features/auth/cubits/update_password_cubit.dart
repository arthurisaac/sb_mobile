import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/features/auth/auth_model.dart';
import 'package:smartbox/features/auth/auth_repository.dart';

@immutable
abstract class UpdatePasswordSate {}

class UpdatePasswordInitial extends UpdatePasswordSate {}

class UpdatePassword extends UpdatePasswordSate {
  final AuthModel authModel;

  UpdatePassword({ required this.authModel});
}

class UpdatePasswordInProgress extends UpdatePasswordSate {
  UpdatePasswordInProgress();
}

class UpdatePasswordSuccess extends UpdatePasswordSate {
  final String message;
  UpdatePasswordSuccess(this.message);
}

class UpdatePasswordFailure extends UpdatePasswordSate {
  final String errorMessage;
  UpdatePasswordFailure(this.errorMessage);
}

class UpdatePasswordCubit extends Cubit<UpdatePasswordSate> {
  final AuthRepository _authRepository;

  UpdatePasswordCubit(this._authRepository) : super(UpdatePasswordInitial());

  void updatePassword({String? password, String? passwordConfirmation}) {
    emit(UpdatePasswordInProgress());
    _authRepository.updatePassword(password: password, passwordConfirmation: passwordConfirmation)
    .then((result) {
      emit(UpdatePasswordSuccess(result));
    }).catchError((e) {
      emit(UpdatePasswordFailure(e.toString()));
    });
  }
}