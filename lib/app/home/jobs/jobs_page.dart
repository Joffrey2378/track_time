import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:track_time/app/home/job_entries/job_entries_page.dart';
import 'package:track_time/app/home/jobs/edit_job_page.dart';
import 'package:track_time/app/home/jobs/job_list_tile.dart';
import 'package:track_time/app/home/jobs/list_item_builder.dart';
import 'package:track_time/common_widgets/platform_alert_dialog.dart';
import 'package:track_time/common_widgets/platform_exception_alert_dialog.dart';
import 'package:track_time/services/auth.dart';
import 'package:track_time/services/database.dart';

import '../models/job.dart';

class JobsPage extends StatelessWidget {
  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('key-${job.id}'),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            background: Container(
              color: Colors.red[700],
            ),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () => EditJobPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }
}
