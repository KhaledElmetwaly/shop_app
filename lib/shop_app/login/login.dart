import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/home.dart';
import 'package:shop_app/network/local/chache_helper.dart';
import 'package:shop_app/shop_app/cubit/login_cubit.dart';
import 'package:shop_app/shop_app/login/register/register_screen.dart';

import '../../components/reusable.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccessState) {
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
          } else if (state is LoginErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
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
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        Text(
                          "Log In Now To browse Our Hot Offers",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
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
                          obscureText: LoginCubit.get(context).isPasswordShown,
                          onFieldSubmitted: (value) {
                            // if (formKey.currentState!.validate()) {
                            //   LoginCubit.get(context).userLogin(
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
                              icon: Icon(LoginCubit.get(context).suffix),
                              onPressed: () {
                                LoginCubit.get(context)
                                    .changePasswordVisibility();
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
                          condition: state is! LoginLoadingState,
                          builder: (context) => Center(
                            child: Container(
                              width: 350,
                              height: 50,
                              color: Colors.deepOrange,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                child: const Text("Log In"),
                              ),
                            ),
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't Have An Account?"),
                            defaultTextButton(
                                function: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()));
                                },
                                text: "Register Now "),
                          ],
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
