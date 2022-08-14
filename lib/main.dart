import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/home.dart';
import 'package:shop_app/components/reusable.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shop_app/bloc_observer.dart';
import 'package:shop_app/shop_app/cubit/login_cubit.dart';
import 'package:shop_app/shop_app/login/login.dart';
import 'package:shop_app/themes/themes.dart';

import 'network/local/chache_helper.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      DioHelper.init();
      await CasheHelper.init();
      Widget widget;
      bool onBoarding = CasheHelper.getData(key: 'onBoarding');
      token = CasheHelper.getData(key: 'token') ?? '';
      HttpOverrides.global = MyHttpOverrides();
      print(token);
      if (onBoarding != null) {
        if (token != '') {
          widget = const HomeLayout();
        } else {
          widget = LoginScreen();
        }
      } else {
        widget = OnBoardingScreen();
      }
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  const MyApp({
    Key? key,
    this.startWidget,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit()
        ..getHomeData()
        ..getCategoriesData()
        ..getFavorites()
        ..getUserData(),
      child: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: startWidget,
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
