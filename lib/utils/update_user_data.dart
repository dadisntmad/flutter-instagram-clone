import 'package:instagram/constants.dart';

Future<void> updateUserDataInCollection(
  String collectionName,
  Map<String, dynamic> data,
) async {
  final collectionRef = db.collection(collectionName);
  final snapshot =
      await collectionRef.where('uid', isEqualTo: auth.currentUser!.uid).get();

  for (final doc in snapshot.docs) {
    await doc.reference.update(data);
  }
}
