import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/reusable.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/network/end_point.dart';
import 'package:shop_app/shop_app/categories/categories.dart';
import 'package:shop_app/shop_app/favourites/favorites.dart';
import 'package:shop_app/shop_app/products/products_screen.dart';
import 'package:shop_app/shop_app/settings/settings.dart';

import '../../models/categories_model.dart';
import '../../models/change_favorites.dart';
import '../../models/favorites_model.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  LoginModel? loginModel;

  Map<int, bool> favorites = {};

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.PostData(url: Login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      if (value.data['status'] == true) {
        loginModel = LoginModel.fromJson(value.data);
        emit(LoginSuccessState(loginModel!));
      } else {
        emit(LoginErrorState(value.data['message']));
      }
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShown = true;
  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;

    suffix = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibility());
  }

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];
  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  void getHomeData() {
    emit(LoginLoadingState());
    DioHelper.getData(
      url: Home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data!.products!) {
        favorites.addAll({element.id!: element.inFavorites!});
      }
      emit(SuccessHomeState());
    }).catchError((error) {
      emit(ErrorHomeState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    emit(LoginLoadingState());
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(SuccessCategoriesState());
    }).catchError((error) {
      print(error);

      emit(ErrorCategoriesState());
      // print(error);
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ChangeFavoritesState());

    DioHelper.PostData(
      url: FAVORITES, data: {'product_id': productId},
// كنا حطين التوكين في الكونستانس
      token: token,
    ).then((value) {
      // if (!changeFavoritesModel!.status!) {
      //   favorites[productId] = !favorites[productId]!;
      // }
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      getFavorites();
      emit(SuccessChangeFavoritesState());
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      log(error.toString());
      emit(ErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(LoginLoadingState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel?.fromJson(value.data);
      emit(SuccessGetFavoritesState());
    }).catchError((error) {
      print(error);

      emit(ErrorGetFavoritesState());
      // print(error);
    });
  }

  LoginModel? userModel;

  void getUserData() {
    emit(LoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = LoginModel?.fromJson(value.data);
      emit(SuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error);

      emit(ErrorUserDataState());
      // print(error);
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(LoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(SuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error);

      emit(ErrorUpdateUserState());
      // print(error);
    });
  }
}
