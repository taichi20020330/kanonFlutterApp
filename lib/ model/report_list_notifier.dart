import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanon_app/data/report.dart';
import 'package:kanon_app/data/work_cateogory.dart';

class ReportListNotifier extends StateNotifier<List<Report>> {
  ReportListNotifier() : super([]) {
    print("_fetchReports");
    _fetchReports();
  }

  final _db = FirebaseFirestore.instance;
  Future<List<WorkCategory>> fetchCategories() async {
    print("fetch cate");

    final snapshot =
        await FirebaseFirestore.instance.collection('workCategories').get();
    final result =
        snapshot.docs.map((doc) => WorkCategory.fromMap(doc)).toList();

    return result;
  }

  void _fetchReports() {
    _db
        .collection('reports')
        .where('deleteFlag', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      final reports = snapshot.docs.map((doc) {
        final data = doc.data();
        return Report(
          id: doc.id,
          startTime: data['startTime'].toDate(),
          endTime: data['endTime'].toDate(),
          roundUpEndTime: data['roundUpEndTime'].toDate(),
          fee: data['fee'],
          user: data['user'],
          helperId: data['helperId'],
          description: data['description'],
          date: data['date'].toDate(),
          deleteFlag: data['deleteFlag'],
          commutingRoute: data['commutingRoute'],
          breakTime: data['breakTime'],
          workCategory: data['workCategory'] != null
              ? Map<String, dynamic>.from(data['workCategory'])
              : null,
        );
      }).toList();
      state = reports;
    });
  }

  Future<void> addReport(Report report) async {
    await _db.collection('reports').add(report.toMap());
  }

  Future<void> updateReport(Report report) async {
    await _db.collection('reports').doc(report.id).update(report.toMap());
    state = [
      for (final r in state)
        if (r.id == report.id) report else r
    ];
  }

  // Future<void> addReport(Report report) async {
  //   await FirebaseFirestore.instance
  //       .collection('reports') // コレクションID指定
  //       .doc() // ドキュメントID自動生成
  //       .set({
  //     'startTime': report.startTime,
  //     'endTime': report.endTime,
  //     'roundUpEndTime': roundTimeToNearest15Minutes(report.endTime),
  //     'fee': fee,
  //     'user': user,
  //     'helperId': helperId,
  //     'description': description,
  //     'date': date,
  //     'breakTime': breakTime,
  //     'commutingRoute' : commutingRoute,
  //     'deleteFlag': false,
  //     'commutingRoute': commutingRoute
  //   });
  // }

  Future<void> deleteReport(String id) async {
    await _db.collection('reports').doc(id).update({'deleteFlag': true});
    state = state.where((r) => r.id != id).toList();
  }
}
