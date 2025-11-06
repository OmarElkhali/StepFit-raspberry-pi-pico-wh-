// Firebase disabled - this service is not currently in use
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  Stream<List<T>> collectionStream<T>(
      {required String path,
      required T Function(Map<String, dynamic> data, String documentId) builder,
      dynamic Function(dynamic query)? queryBuilder,
      int Function(T lhs, T rhs)? sort}) {
    // Firebase disabled - returning empty stream
    debugPrint('FirestoreService disabled: collectionStream called for $path');
    return Stream.value([]);
  }

  Future<void> deleteData({required String path}) async {
    debugPrint('FirestoreService disabled: delete called for $path');
  }

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    debugPrint(
        'FirestoreService disabled: setData called for $path with data: $data');
  }

  Stream<T> documentStream<T>(
      {required String path,
      required T Function(Map<String, dynamic> data, String documentId)
          builder}) {
    // Firebase disabled - returning stream with default/empty data
    debugPrint('FirestoreService disabled: documentStream called for $path');
    return Stream.value(builder({}, ''));
  }
}
