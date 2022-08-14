import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/network/local/chache_helper.dart';
import 'package:shop_app/shop_app/cubit/login_cubit.dart';
import 'package:shop_app/shop_app/login/login.dart';
import 'package:shop_app/themes/colors.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is SuccessUserDataState) {
          nameController.text = state.loginModel.data!.name!;
          emailController.text = state.loginModel.data!.email!;
          phoneController.text = state.loginModel.data!.phone!;
        }
      },
      builder: (context, state) {
        var model = LoginCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
        return ConditionalBuilder(
          condition: LoginCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: formKey,
                child: Column(children: [
                  if (state is LoadingUpdateUserState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Name Must not Be Empty';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: DefaultColor),
                      ),
                      labelText: 'Name',
                      prefix: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Email Must not Be Empty';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: DefaultColor),
                      ),
                      labelText: 'Email',
                      prefix: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: phoneController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Phone Must not Be Empty';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: DefaultColor),
                      ),
                      labelText: 'Phone',
                      prefix: const Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.deepOrange,
                    width: 300,
                    height: 50,
                    child: TextButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          LoginCubit.get(context).updateUserData(
                            name: nameController.text,
                            phone: phoneController.text,
                            email: emailController.text,
                          );
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(
                            backgroundColor: Colors.deepOrange,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.deepOrange,
                    width: 300,
                    height: 50,
                    child: TextButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        CasheHelper.removeData(key: 'token').then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) => false);
                        });
                      },
                      child: const Text(
                        'SIGN OUT',
                        style: TextStyle(
                            backgroundColor: Colors.deepOrange,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          fallback: (context) => const CircularProgressIndicator(),
        );
      },
    );
  }
}
