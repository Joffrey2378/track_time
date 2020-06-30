import 'package:flutter_test/flutter_test.dart';
import 'package:track_time/app/home/models/job.dart';

void main() {
  group('from map', () {
    test('null', () {
      final job = Job.fromMap(null, 'abc');
      expect(job, null);
    });

    test('job w/ all properties', () {
      final job = Job.fromMap({
        'name': 'jobName1',
        'ratePerHour': 1000000,
      }, 'abc');
      expect(job, Job(id: 'abc', name: 'jobName1', ratePerHour: 1000000));
    });

    test('missing name', () {
      final job = Job.fromMap({
        'ratePerHour': 1000000,
      }, 'abc');
      expect(job, null);
    });
  });

  group('toMap', () {
    test('valid fields', () {
      final job = Job(id: 'abc', name: 'jobName1', ratePerHour: 1000000);
      expect(job.toMap(), {
        'name': 'jobName1',
        'ratePerHour': 1000000,
      });
    });
  });
}
