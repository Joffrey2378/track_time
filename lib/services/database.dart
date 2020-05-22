import 'package:flutter/foundation.dart';
import 'package:track_time/app/home/models/job.dart';
import 'package:track_time/services/api_path.dart';
import 'package:track_time/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );

  Future<void> createJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, documentIdFromCurrentDate()),
        data: job.toMap(),
      );
}
