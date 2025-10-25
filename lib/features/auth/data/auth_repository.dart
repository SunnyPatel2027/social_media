import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/app_exceptions.dart';
import 'user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  User? get currentUser => _auth.currentUser;

  Future<UserModel> signUp(String email, String password, String username) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = cred.user!;
      final model = UserModel(uid: user.uid, email: email, username: username);
      await _firestore.collection(AppConstants().usersCollection).doc(user.uid).set(model.toMap());
      await _secure.write(key: 'uid', value: user.uid);
      return model;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Signup failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = cred.user!;
      final model = await getUserById(user.uid) ?? UserModel(uid: user.uid, email: email, username: '');
      await _secure.write(key: 'uid', value: user.uid);
      return model;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Login failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection(AppConstants().usersCollection).doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data(), uid);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _secure.delete(key: 'uid');
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<String?> getSavedUid() => _secure.read(key: 'uid');
}
