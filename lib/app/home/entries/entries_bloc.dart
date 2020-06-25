import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:track_time/app/home/entries/daily_jobs_details.dart';
import 'package:track_time/app/home/entries/entries_list_tile.dart';
import 'package:track_time/app/home/entries/entry_job.dart';
import 'package:track_time/app/home/job_entries/format.dart';
import 'package:track_time/app/home/models/entry.dart';
import 'package:track_time/app/home/models/job.dart';
import 'package:track_time/services/database.dart';

class EntriesBloc {
  EntriesBloc({@required this.database});
  final Database database;

  Stream<List<EntryJob>> get _allEntriesStream => Observable.combineLatest2(
        database.entriesStream(),
        database.jobsStream(),
        _entriesJobsCombiner,
      );

  static List<EntryJob> _entriesJobsCombiner(
      List<Entry> entries, List<Job> jobs) {
    return entries.map((entry) {
      final job = jobs.firstWhere((job) => job.id == entry.jobId);
      return EntryJob(entry, job);
    }).toList();
  }

  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryJob> allEntries) {
    final allDailyJobsDetails = DailyJobsDetails.all(allEntries);

    final totalDuration = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    final totalPay = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.pay)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyJobsDetails.date),
          middleText: Format.currency(dailyJobsDetails.pay),
          trailingText: Format.hours(dailyJobsDetails.duration),
        ),
        for (JobDetails jobDuration in dailyJobsDetails.jobsDetails)
          EntriesListTileModel(
            leadingText: jobDuration.name,
            middleText: Format.currency(jobDuration.pay),
            trailingText: Format.hours(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
