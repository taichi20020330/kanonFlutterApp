import 'package:cloud_firestore/cloud_firestore.dart';

class WorkCategory {
  final String id;
  final String name;
  final List<String> sub;

  WorkCategory({
    required this.id,
    required this.name,
    required this.sub,
  });

  factory WorkCategory.fromMap(DocumentSnapshot doc) {
    return WorkCategory(
      id: doc.id,
      name: doc['name'] ?? '',
      sub: List<String>.from(doc['sub'] ?? []),
    );
  }
}
