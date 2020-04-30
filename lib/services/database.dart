import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:track_time/app/home/models/job.dart';
import 'package:track_time/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;

  Future<void> createJob(Job job) async {
    final path = APIPath.job(uid, 'job_123');
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(job.toMap());
  }
}
