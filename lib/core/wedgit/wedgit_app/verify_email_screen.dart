import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/perthon/cubit/auth_cubit.dart';
import '../../../auth/perthon/cubit/auth_state.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081A2B),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is EmailVerified) {
            Navigator.pushReplacementNamed(context, "/ClientHomeScreen");
          }

          if (state is EmailVerificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "تم إرسال رابط التفعيل إلى بريدك الإلكتروني.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().sendVerificationEmail();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("إعادة إرسال الرابط"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().checkVerification();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("تحقق الآن"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
