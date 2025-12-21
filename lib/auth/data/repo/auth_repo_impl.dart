import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_repository.dart';


class AuthRepoImpl implements AuthRepository {
  @override
  FirebaseAuth get auth => FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final credential =
    await auth.signInWithEmailAndPassword(email: email, password: password);

    final uid = credential.user!.uid;

    final doc = await _firestore.collection("users").doc(uid).get();

    if (!doc.exists) {
      throw Exception("User data not found");
    }

    return doc.data()!;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential =
    await auth.createUserWithEmailAndPassword(email: email, password: password);

    final user = credential.user!;
    await user.updateDisplayName(name);

    await user.sendEmailVerification();

    final docRef = _firestore.collection("users").doc(user.uid);

    final userData = {
      "id": user.uid,
      "uid": user.uid,
      "name": name,
      "email": email.toLowerCase(),
      "role": "client",
      "token": "invalid",
      "createdAt": FieldValue.serverTimestamp(),
    };

    await docRef.set(userData);

    return userData;
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCred = await auth.signInWithCredential(credential);
    final user = userCred.user!;

    final docRef = _firestore.collection("users").doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final userData = {
        "id": user.uid,
        "uid": user.uid,
        "name": user.displayName ?? "No Name",
        "email": user.email?.toLowerCase(),
        "role": "client",
        "token": "invalid",
        "createdAt": FieldValue.serverTimestamp(),
      };
      await docRef.set(userData);
      return userData;
    }

    return doc.data()!;
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    final user = auth.currentUser;
    if (user == null) return false;

    await user.reload();
    return user.emailVerified;
  }
}

