import 'package:app_alfardos/core/wedgit/wedgit_app/passward.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../core/wedgit/wedgit_app/coloers.dart';
import '../../../../core/wedgit/wedgit_app/custom_bottom.dart';
import '../../../../core/wedgit/wedgit_app/custom_text_form.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwardController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isDialogOpen = false;

  void showLoading() {
    if (!isDialogOpen) {
      isDialogOpen = true;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        title: "جاري التحميل",
        desc: "يتم إنشاء الحساب...",
        dismissOnTouchOutside: false,
      ).show();
    }
  }

  void closeLoading() {
    if (isDialogOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) showLoading();
          if (state is AuthSuccess) {
            closeLoading();
            final userData = state.userData;
            Navigator.pushNamed(
              context,
              Routes.verifyEmailScreen,
              arguments: userData,
            );
          }
          if (state is AuthError) {
            closeLoading();
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: "خطأ",
              desc: state.message,
              btnOkOnPress: () {},
            ).show();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
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
                        children: [
                          SizedBox(height: 30.h),
                          Image.asset(
                            "asset/image/logoo.png",
                            height: 200.h,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Create a new account for free",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: MyColorsApp.fontColor,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomTextForm(
                    hintText: "Osama Yosef",
                    lapText: "Name",
                    controller: nameController,
                    validator: (v) =>
                    v == null || v.isEmpty ? "Name is required" : null,
                  ),
                  SizedBox(height: 30.h),
                  CustomTextForm(
                    hintText: "example@email.com",
                    lapText: "Email",
                    controller: emailController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Email is required";
                      if (!v.contains("@")) return "Enter a valid email";
                      return null;
                    },
                  ),
                  SizedBox(height: 30.h),
                  Password(controller: passwardController),
                  SizedBox(height: 40.h),
                  CustomBottom(
                    titel: "Register",
                    onTap: () {
                      if (!_formKey.currentState!.validate()) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: "خطأ",
                          desc: "من فضلك املأ كل الحقول",
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }

                      context.read<AuthCubit>().register(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwardController.text.trim(),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.loginScreen),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(color: MyColorsApp.mainColor),
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

