import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import 'post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection(AppConstants().postsCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => PostModel.fromDoc(d)).toList());
  }

  Future<void> createPost(String message, String username) async {
    await _firestore.collection(AppConstants().postsCollection).add({
      'message': message,
      'username': username,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
