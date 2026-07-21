import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_template/core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e, 'Login failed. Please try again.');
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Server error. Please try again.', cause: e);
    } on SocketException catch (e) {
      throw AuthException('No internet connection. Please check your network.', cause: e);
    } on TimeoutException catch (e) {
      throw AuthException('Connection timed out. Please try again.', cause: e);
    } catch (e) {
      throw AuthException(e.toString(), cause: e);
    }
  }

  @override
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e, 'Registration failed. Please try again.');
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Server error. Please try again.', cause: e);
    } on SocketException catch (e) {
      throw AuthException('No internet connection. Please check your network.', cause: e);
    } on TimeoutException catch (e) {
      throw AuthException('Connection timed out. Please try again.', cause: e);
    } catch (e) {
      throw AuthException(e.toString(), cause: e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e, 'Sign out failed. Please try again.');
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Server error. Please try again.', cause: e);
    } on SocketException catch (e) {
      throw AuthException('No internet connection. Please check your network.', cause: e);
    } catch (e) {
      throw AuthException(e.toString(), cause: e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(
        e,
        'Failed to send the password reset email. Please try again.',
      );
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Server error. Please try again.', cause: e);
    } on SocketException catch (e) {
      throw AuthException('No internet connection. Please check your network.', cause: e);
    } catch (e) {
      throw AuthException(e.toString(), cause: e);
    }
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  AuthException _mapFirebaseAuthException(
    FirebaseAuthException e,
    String defaultMessage,
  ) {
    String msg = defaultMessage;
    switch (e.code) {
      case 'wrong-password':
        msg = 'Incorrect password. Please try again.';
        break;
      case 'invalid-email':
        msg = 'Please enter a valid email address.';
        break;
      case 'user-not-found':
        msg = 'No account was found with this email.';
        break;
      case 'invalid-credential':
        msg = 'Incorrect email or password.';
        break;
      case 'email-already-in-use':
        msg = 'An account with this email already exists.';
        break;
      case 'weak-password':
        msg = 'Password is too weak. Please choose a stronger password.';
        break;
      case 'network-request-failed':
        msg = 'Network error. Please check your internet connection.';
        break;
      case 'too-many-requests':
        msg = 'Too many attempts. Please try again later.';
        break;
    }
    return AuthException(msg, code: e.code, cause: e);
  }
}
