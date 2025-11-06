// import 'package:firebase_auth/firebase_auth.dart'; // Firebase disabled
import 'package:injectable/injectable.dart';
import 'package:flutter_steps_tracker/features/intro/data/data_sources/auth_remote_data_source.dart';

abstract class AuthBase {
  Future<MockUser?> signInAnonymously();
}

@Singleton(as: AuthBase)
class Auth implements AuthBase {
  // Firebase disabled - using mock authentication

  @override
  Future<MockUser?> signInAnonymously() async {
    // Mock implementation - return a fake user
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    return MockUser(
        'mock_anonymous_user_${DateTime.now().millisecondsSinceEpoch}');
  }
}
