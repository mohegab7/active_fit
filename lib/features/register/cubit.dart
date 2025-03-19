
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opennutritracker/features/register/states.dart';
import 'package:opennutritracker/model/model.dart';

class RegisterCuibt extends Cubit<RegisterStates> {
  RegisterCuibt() : super(Registerintinalstate());
  static RegisterCuibt get(context) => BlocProvider.of(context);

  void userRegister({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) {
    emit(RegisterloadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      // print(value.user?.email);
      // print(value.user?.uid);
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
      );
      // emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    UserModel model = UserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      image:
          'https://img.freepik.com/premium-photo/photo-curly-teen-girl-with-wavy-hair-banner-curly-teen-girl-isolated-white-curly-teen-girl-studio-curly-teen-girl-background_474717-147568.jpg?w=1380',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((Error) {
      emit(CreateUserErrorState(Error.toString()));
    });
  }

  bool ispassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changepassword() {
    ispassword = !ispassword;
    suffix = ispassword ? Icons.visibility_off : Icons.visibility_outlined;
    emit(RegisterChangePasswordState());
  }
}
