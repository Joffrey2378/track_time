import 'package:flutter/foundation.dart';

class Job {
  final String id;
  final String name;
  final int ratePerHour;

  Job({@required this.id, @required this.name, @required this.ratePerHour});

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) return null;
    final int ratePerHour = data['ratePerHour'];
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': '$name',
      'ratePerHour': ratePerHour,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Job &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          ratePerHour == other.ratePerHour;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ ratePerHour.hashCode;

  @override
  String toString() {
    return 'id: $id, name: $name, ratePerHour: $ratePerHour';
  }
}
