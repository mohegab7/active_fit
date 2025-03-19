import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opennutritracker/core/presentation/main_screen.dart';
import 'package:opennutritracker/features/login/cubit.dart';
import 'package:opennutritracker/features/login/states.dart';
import 'package:opennutritracker/features/register/Register_screen.dart';
import 'package:opennutritracker/model/constants/constants.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  var formkey = GlobalKey<FormState>();
  var emailcontroll = TextEditingController();
  var passwordcontroll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => LoginCuibt(),
        child: BlocConsumer<LoginCuibt, LoginStates>(
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        const SizedBox(
                          width: 120,
                        ),
                        const Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 160.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              border: Border.all(
                                width: 2,
                                color: const Color(0xff49D199),
                              ),
                            ),
                            child: TextFormField(
                              controller: emailcontroll,
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              // onFieldSubmitted: onSubmit,
                              // controller: controller,

                              keyboardType: TextInputType.emailAddress,

                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              border: Border.all(
                                width: 2,
                                color: const Color(0xff49D199),
                              ),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Password';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                if (formkey.currentState!.validate()) {
                                  LoginCuibt.get(context).userLogin(
                                    email: emailcontroll.text,
                                    password: passwordcontroll.text,
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              controller: passwordcontroll,
                              obscureText: LoginCuibt.get(context).ispassword,
                              keyboardType: TextInputType.visiblePassword,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    LoginCuibt.get(context).changepassword();
                                  },
                                  icon: Icon(LoginCuibt.get(context).suffix),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 30,
                        // ),

                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: ConditionalBuilder(
                            condition: true,
                            builder: (BuildContext context) {
                              return Container(
                                width: 370,
                                height: 52,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // if (formkey.currentState!.validate()) {
                                    //   LoginCuibt.get(context).userLogin(
                                    //     email: emailcontroll.text,
                                    //     password: passwordcontroll.text,
                                    //   );

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    // }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ).copyWith(
                                      elevation:
                                          ButtonStyleButton.allOrNull(0.0)),
                                  icon:
                                      const Icon(Icons.navigate_next_outlined),
                                  label: Text('Login',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge),
                                ),
                              );
                            },
                            fallback: (Context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15),
                            child: Container(
                              width: 370,
                              height: 52,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ).copyWith(
                                      elevation:
                                          ButtonStyleButton.allOrNull(0.0)),
                                  icon:
                                      const Icon(Icons.navigate_next_outlined),
                                  label: Text('Register',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)),
                            )),

                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue,
                                size: 40,
                              ),
                              onPressed: () {
                                print("Facebook icon clicked!");
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.google,
                                    size: 35)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state is LoginErrorState) {
              Fluttertoast.showToast(
                msg: 'error email or password',
                backgroundColor: Colors.red,
                fontSize: 20,
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
              );
            }
            if (state is LoginSuccessState) {
              CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                  (route) => false,
                );
              });
            }
          },
        ));
  }
}
