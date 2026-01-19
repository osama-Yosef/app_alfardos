import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repo/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final userData = await repo.login(email: email, password: password);

      final role = userData['role'] ?? 'client';
      emit(AuthSuccess(role));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final userData = await repo.register(
        name: name,
        email: email,
        password: password,
      );

      final role = userData['role'] ?? 'client';
      emit(AuthSuccess(role, userData: userData));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError("حدث خطأ غير متوقع"));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final userData = await repo.signInWithGoogle();
      final role = userData['role'] ?? 'client';
      emit(AuthSuccess(role));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError("حدث خطأ غير متوقع"));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoading());
    try {
      if (email.isEmpty || !email.contains("@")) {
        emit(ResetPasswordError("الرجاء إدخال بريد إلكتروني صالح"));
        return;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      emit(
        ResetPasswordSuccess("تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك"),
      );
    } on FirebaseAuthException catch (e) {
      emit(ResetPasswordError(_mapFirebaseError(e)));
    } catch (e) {
      emit(ResetPasswordError("حدث خطأ غير متوقع"));
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await repo.sendEmailVerification();
      emit(EmailVerificationSent());
    } catch (e) {
      emit(EmailVerificationError("تعذر إرسال رابط التفعيل"));
    }
  }

  Future<void> checkVerification() async {
    try {
      final isVerified = await repo.checkEmailVerified();

      if (isVerified) {
        emit(EmailVerified());
      } else {
        emit(EmailVerificationError("لم يتم التفعيل بعد"));
      }
    } catch (e) {
      emit(EmailVerificationError("حدث خطأ أثناء التحقق"));
    }
  }
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return "البريد الإلكتروني غير صالح";

      case "wrong-password":
      case "invalid-password":
      case "invalid-credential":
      case "INVALID_LOGIN_CREDENTIALS":
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة";

      case "user-not-found":
        return "لا يوجد حساب بهذا البريد الإلكتروني";

      case "user-disabled":
        return "تم تعطيل هذا الحساب";

      case "email-already-in-use":
        return "هذا البريد الإلكتروني مستخدم بالفعل";

      case "weak-password":
        return "كلمة المرور ضعيفة، يجب أن تكون أقوى";

      case "too-many-requests":
        return "محاولات كثيرة، حاول مرة أخرى لاحقًا";

      case "network-request-failed":
        return "تحقق من اتصال الإنترنت";

      default:
        return "بيانات تسجيل الدخول غير صحيحة";
    }
  }

}
