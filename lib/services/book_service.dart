import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/book.dart';
import '../models/dynamic_metadata.dart';

class BookService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Book>> getBooks() {
    return _db.collection('books').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Book.fromFirestore(doc.data(), doc.id)).toList());
  }

  Future<String> getDownloadUrl(String storageUrl) async {
    final ref = _storage.refFromURL(storageUrl);
    return await ref.getDownloadURL();
  }

  Future<void> addDynamicMetadata(String bookId, DynamicMetadata metadata) async {
    await _db.collection('books').doc(bookId).update({
      'dynamicMetadata': FieldValue.arrayUnion([metadata.toMap()])
    });
  }

  Future<void> removeDynamicMetadata(String bookId, DynamicMetadata metadata) async {
    await _db.collection('books').doc(bookId).update({
      'dynamicMetadata': FieldValue.arrayRemove([metadata.toMap()])
    });
  }
}
