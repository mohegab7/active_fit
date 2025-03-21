abstract class LoginStates {}

class Loginintinalstate extends LoginStates {}

class LoginloadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  // final String uId;

  // LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  LoginErrorState(this.error);

  final String error;
}

class ChangePasswordState extends LoginStates {}
