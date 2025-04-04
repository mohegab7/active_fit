import 'package:active_fit/features/login/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCuibt extends Cubit<LoginStates> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  LoginCuibt() : super(Loginintinalstate());
  static LoginCuibt get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginloadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);

      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

//   login() async{
// final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
// final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
// final credential = GoogleAuthProvider.credential(
//  accessToken: googleAuth?. accessToken, 
//  idToken: googleAuth?. idToken,
// );
// await FirebaseAuth. instance. signInWithCredential (credential as AuthCredential);
//   }

Future<User?> signInWithGoogle() async {  
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();  
  
  if (googleUser == null) {  
    // عملية تسجيل الدخول تم إلغاؤها  
    return null;  
  }  

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;  

  if (googleAuth.accessToken == null && googleAuth.idToken == null) {  
    // السلطة لم يتم الحصول عليها بشكل صحيح  
    throw Exception('مشكلة في الحصول على access token أو id token');  
  }  

  final credential = GoogleAuthProvider.credential(  
    accessToken: googleAuth.accessToken,  
    idToken: googleAuth.idToken,  
  );  

  final FirebaseAuth auth = FirebaseAuth.instance;  
  UserCredential userCredential = await auth.signInWithCredential(credential);  
  return userCredential.user;  
}


  bool ispassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changepassword() {
    ispassword = !ispassword;
    suffix = ispassword ? Icons.visibility_off : Icons.visibility_outlined;
    emit(ChangePasswordState());
  }

  
}

