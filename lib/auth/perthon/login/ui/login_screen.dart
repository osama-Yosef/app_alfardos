import 'package:app_alfardos/core/wedgit/wedgit_app/passward.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../admin/factuors/eng_screen/perthon/ui/eng_screen.dart';
import '../../../../core/wedgit/wedgit_app/coloers.dart';
import '../../../../core/wedgit/wedgit_app/custom_bottom.dart';
import '../../../../core/wedgit/wedgit_app/custom_text_form.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwardController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isDialogOpen = false;

  void showLoading(BuildContext context) {
    if (!isDialogOpen) {
      isDialogOpen = true;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        title: "Loading...",
      ).show();
    }
  }

  void closeLoading(BuildContext context) {
    if (isDialogOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) showLoading(context);

        if (state is AuthSuccess) {
          closeLoading(context);

          final userData = state.userData;

          if (state.role == "admin") {
            Navigator.pushNamed(context, Routes.homeScreen, arguments: userData);
          } else if (state.role == "eng") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EngScreen()),
            );
          } else {
            Navigator.pushNamed(
              context,
              Routes.ClientHomeScreen,
              arguments: userData,
            );
          }
        }

        if (state is AuthError) {
          closeLoading(context);

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: "Error",
            desc: state.message,
          ).show();
        }

        if (state is ResetPasswordLoading) showLoading(context);

        if (state is ResetPasswordSuccess) {
          closeLoading(context);

          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: "Success",
            desc: state.message,
          ).show();
        }

        if (state is ResetPasswordError) {
          closeLoading(context);

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: "Error",
            desc: state.message,
          ).show();
        }
      },


    child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF1F6),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100.r),
                            bottomRight: Radius.circular(100.r),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Image.asset(
                            "asset/image/logoo.png",
                            height: 200.h,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 40.h),

                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Login to your account",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: MyColorsApp.mainColor,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  CustomTextForm(
                    controller: emailController,
                    hintText: "example@email.com",
                    lapText: "Email",
                    validator: (v) =>
                    v == null || v.isEmpty ? "Email is required" : null,
                  ),

                  SizedBox(height: 30.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  Password(controller: passwardController),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          final email = emailController.text.trim();

                          if (email.isEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              title: "تنبيه",
                              desc: "الرجاء إدخال البريد الإلكتروني أولًا",
                            ).show();
                            return;
                          }

                          context.read<AuthCubit>().resetPassword(email);
                        },
                        child: const Text(
                          "? Forgot password",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 60.h),

                  CustomBottom(
                    titel: "Login",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().login(
                          emailController.text.trim(),
                          passwardController.text.trim(),
                        );
                      }
                    },
                  ),

                  SizedBox(height: 15.h),

                  InkWell(
                    onTap: () {
                      context.read<AuthCubit>().signInWithGoogle();
                    },
                    child: Container(
                      height: 50.h,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "asset/image/Google-Logo.jpg",
                            height: 24.h,
                          ),
                          SizedBox(width: 12.w),
                          const Text(
                            "تسجيل الدخول عبر Google",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.registerScreen);
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Don’t have an account? ",
                            style: TextStyle(fontSize: 14),
                          ),
                          TextSpan(
                            text: "Create account",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: MyColorsApp.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
