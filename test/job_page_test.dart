import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:track_time/app/home/jobs/job_list_tile.dart';
import 'package:track_time/app/home/jobs/jobs_page.dart';
import 'package:track_time/app/home/models/job.dart';
import 'package:track_time/services/database.dart';

import 'mocks.dart';

void main() {
  MockDatabase mockDatabase;
  StreamController<List<Job>> onJobsController;

  setUp(() {
    mockDatabase = MockDatabase();
    onJobsController = StreamController<List<Job>>();
  });

  tearDown(() {
    onJobsController.close();
  });

  Future<void> pumpJobsPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<Database>(
        create: (_) => mockDatabase,
        child: MaterialApp(
          home: JobsPage(),
        ),
      ),
    );
    await tester.pump();
  }

  void stubJobsStream(Iterable<List<Job>> jobsStream) {
    onJobsController.addStream(Stream<List<Job>>.fromIterable(jobsStream));
    when(mockDatabase.jobsStream()).thenAnswer((_) => onJobsController.stream);
  }

  testWidgets('stream waiting', (WidgetTester tester) async {
    stubJobsStream([]);

    await pumpJobsPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('null job', (WidgetTester tester) async {
    stubJobsStream([null]);

    await pumpJobsPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('non-null job', (WidgetTester tester) async {
    stubJobsStream([
      [Job(id: '123', name: 'Working', ratePerHour: 12)]
    ]);

    await pumpJobsPage(tester);

    expect(find.byType(JobListTile), findsOneWidget);
  });
}
