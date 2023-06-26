import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbox/features/auth/auth_model.dart';
import 'package:smartbox/features/auth/auth_repository.dart';

@immutable
abstract class UpdateProfileSate {}

class UpdateProfileInitial extends UpdateProfileSate {}

class UpdateProfile extends UpdateProfileSate {
  final AuthModel authModel;

  UpdateProfile({ required this.authModel});
}

class UpdateProfileInProgress extends UpdateProfileSate {
  UpdateProfileInProgress();
}

class UpdateProfileSuccess extends UpdateProfileSate {
  final String message;

  UpdateProfileSuccess(this.message);
}

class UpdateProfileFailure extends UpdateProfileSate {
  final String errorMessage;
  UpdateProfileFailure(this.errorMessage);
}

class UpdateProfileCubit extends Cubit<UpdateProfileSate> {
  final AuthRepository _authRepository;

  UpdateProfileCubit(this._authRepository) : super(UpdateProfileInitial());

  void updateProfile({String? nom, String? prenom, String? telephone}) {
    emit(UpdateProfileInProgress());
    _authRepository.updateUser(nom: nom, prenom: prenom, telephone: telephone)
    .then((message) {
      emit(UpdateProfileSuccess(message));
    }).catchError((e) {
      emit(UpdateProfileFailure(e.toString()));
    });
  }
}