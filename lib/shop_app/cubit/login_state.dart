part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class ShopChangeBottomNavState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginModel loginModel;

  LoginSuccessState(this.loginModel);
}

class SuccessHomeState extends LoginState {}

class ErrorHomeState extends LoginState {}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}

class ChangePasswordVisibility extends LoginState {}

class SuccessCategoriesState extends LoginState {}

class ErrorCategoriesState extends LoginState {}

class SuccessChangeFavoritesState extends LoginState {}

class ChangeFavoritesState extends LoginState {}

class ErrorChangeFavoritesState extends LoginState {}

class SuccessGetFavoritesState extends LoginState {}

class ErrorGetFavoritesState extends LoginState {}

class SuccessUserDataState extends LoginState {
  final LoginModel loginModel;

  SuccessUserDataState(this.loginModel);
}

class ErrorUserDataState extends LoginState {}

class LoadingUserDataState extends LoginState {}

class SuccessUpdateUserState extends LoginState {
  final LoginModel loginModel;

  SuccessUpdateUserState(this.loginModel);
}

class ErrorUpdateUserState extends LoginState {}

class LoadingUpdateUserState extends LoginState {}
