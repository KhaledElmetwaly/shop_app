import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';

import '../cubit/login_cubit.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) => buildCategoriesItem(
                  LoginCubit.get(context).categoriesModel!.data!.data![index],
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount:
                LoginCubit.get(context).categoriesModel!.data!.data!.length);
      },
    );
  }

  Widget buildCategoriesItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image!),
              width: 130,
              height: 130,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              model.name!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      );
}
