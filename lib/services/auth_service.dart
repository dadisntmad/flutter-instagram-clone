import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/models/user_model.dart';

class AuthService {
  // check if username already exists
  Future<bool> isUsernameAlreadyExists(String username) async {
    final result = await db
        .collection('users')
        .where("username", isEqualTo: username)
        .get();

    return result.docs.isNotEmpty;
  }

  //  sign up
  Future<String> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    String res = '';

    try {
      final isNotValid = await isUsernameAlreadyExists(username);

      if (isNotValid) {
        return res = 'The username $username already exists';
      }

      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        final userCred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        UserModel user = UserModel(
          uid: userCred.user!.uid,
          username: username,
          email: email,
          imageUrl: '',
          fullName: '',
          following: [],
          followers: [],
        );

        await db.collection('users').doc(userCred.user!.uid).set(user.toJson());

        res = 'Success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // sign in
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String res = '';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        res = 'Success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password provided for that user.';
      }
    }
    return res;
  }

  // sign out
  Future<void> signOut() async {
    await auth.signOut();
  }
}
