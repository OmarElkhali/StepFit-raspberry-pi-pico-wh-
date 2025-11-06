// import 'package:firebase_auth/firebase_auth.dart'; // Firebase disabled
// import 'package:flutter/foundation.dart';
// import 'package:flutter_steps_tracker/core/data/error/exceptions/firebase_auth_exception_app.dart';

abstract class ApplicationException implements Exception {}

class GenericApplicationException extends ApplicationException {
  final String message;

  GenericApplicationException({required this.message});
}

// Firebase error decoder - disabled as Firebase is not in use
// void firebaseErrorDecoder(dynamic e) {
//   debugPrint(e.toString());
//   throw GenericApplicationException(message: 'Something went wrong!');
// }

// void decodeAuthException(dynamic e) {
//   // We need just the anonymous one for now, but for more
//   // we will create enum with the types
//   throw GenericApplicationException(message: 'Something went wrong!');
// }

