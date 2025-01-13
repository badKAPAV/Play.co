import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musify/core/config/constants/app_urls.dart';
import 'package:musify/data/models/auth/create_user_req.dart';
import 'package:musify/data/models/auth/signin_user_req.dart';
import 'package:musify/data/models/auth/user.dart';
import 'package:musify/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SigninUserReq signinUserReq);
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> getUser();
  Future<Either<String, String>> signout();
  Stream<UserEntity?> authStateChanges();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signinUserReq.email, password: signinUserReq.password);

      return const Right('Successfully logged in');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'This email is not registered';
      } else if (e.code == 'invalid-credential') {
        message = 'The entered password doesn\'t match';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createUserReq.email, password: createUserReq.password);

      FirebaseFirestore.instance.collection('Users').doc(data.user?.uid).set({
        'name': createUserReq.fullName,
        'email': data.user?.email,
      });

      return const Right('Signup was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = await firebaseFirestore
          .collection('Users')
          .doc(firebaseAuth.currentUser?.uid)
          .get();

      UserModel userModel = UserModel.fromJson(user.data()!);

      userModel.imageUrl =
          firebaseAuth.currentUser?.photoURL ?? AppUrls.defaultImage;

      UserEntity userEntity = userModel.toEntity();

      return Right(userEntity);
    } catch (e) {
      return Left('An error occured');
    }
  }

  @override
  Future<Either<String, String>> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return const Right('Successfully logged out');
    } catch (e) {
      return const Left('Failed to logout');
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        var userData = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        UserModel userModel = UserModel.fromJson(userData.data()!);
        userModel.imageUrl = user.photoURL ?? AppUrls.defaultImage;

        return userModel.toEntity();
      } catch (e) {
        return null;
      }
    });
  }
}
