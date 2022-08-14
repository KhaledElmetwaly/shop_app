import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/home.dart';
import 'package:shop_app/components/reusable.dart';
import 'package:shop_app/network/local/chache_helper.dart';
import 'package:shop_app/shop_app/login/register/register_cubit.dart';
import 'package:shop_app/shop_app/login/register/register_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status!) {
              print(state.loginModel.message);
              print(state.loginModel.data!.token);
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              CasheHelper.saveDate(
                      key: 'token', value: state.loginModel.data!.token!)
                  .then((value) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => const HomeLayout()),
                    (route) {
                  return false;
                });
              });
              // CasheHelper.saveDate(
              //         key: 'token', value: state.loginModel.data!.token)
              //     .then((value) {
              //   Navigator.pushAndRemoveUntil(context,
              //       MaterialPageRoute(builder: (context) => const HomeLayout()),
              //       (route) {
              //     return false;
              //   });
              // });
              showToast(
                  text: state.loginModel.message!, state: ToastStates.SUCCESS);
            }
          } else if (state is ShopRegisterErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        Text(
                          "Register Now To browse Our Hot Offers",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your Name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.deepOrange),
                                borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            labelText: "Name",
                            prefixIcon:
                                const Icon(Icons.supervised_user_circle_sharp),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your Phone Number";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.deepOrange),
                                borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            labelText: "Phone Number",
                            prefixIcon:
                                const Icon(Icons.phone_android_outlined),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.deepOrange),
                                borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            labelText: "Email Address",
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          obscureText:
                              ShopRegisterCubit.get(context).isPassword,
                          onFieldSubmitted: (value) {
                            // if (formKey.currentState!.validate()) {
                            //   ShopRegisterCubit.get(context).userLogin(
                            //     email: emailController.text,
                            //     password: passwordController.text,
                            //   );
                            // }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password Is To short ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.deepOrange,
                              ),
                            ),
                            labelText: "Password",
                            filled: true,
                            // hintStyle: TextStyle(color: Colors.deepOrange),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(ShopRegisterCubit.get(context).suffix),
                              onPressed: () {
                                // ShopRegisterCubit.get(context)
                                // .changePasswordVisibility();
                              },
                            ),

                            // validator: (String? value) {
                            //   if (value!.isEmpty) {
                            //     return "Please Enter Your Password";
                            //   }
                            //   return null;
                            // },
                          ),
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => Center(
                            child: Container(
                              width: 350,
                              height: 50,
                              color: Colors.deepOrange,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                child: const Text("Register"),
                              ),
                            ),
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
