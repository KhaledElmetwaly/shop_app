import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/reusable.dart';

import 'package:shop_app/shop_app/cubit/login_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return ListView.separated(
          itemBuilder: (context, index) => buildListProduct(cubit,
              cubit.favoritesModel!.data!.data![index].product!, context),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: LoginCubit.get(context).favoritesModel!.data!.data!.length,
        );
      },
    );
  }
}
