// import 'package:firebase_auth/firebase_auth.dart'; // Firebase disabled
import 'package:flutter_steps_tracker/core/data/data_sources/data_sources_body.dart';
import 'package:flutter_steps_tracker/features/intro/data/services/auth_services.dart';
import 'package:injectable/injectable.dart';

// Mock User class to replace Firebase User
class MockUser {
  final String uid;
  MockUser(this.uid);
}

abstract class AuthRemoteDataSource {
  Future<MockUser?> signInAnonymously();
}

@Singleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final AuthBase authBase;

  AuthRemoteDataSourceImpl({required this.authBase});

  @override
  Future<MockUser?> signInAnonymously() async => returnOrThrow(
        () => authBase.signInAnonymously(),
      );
}
