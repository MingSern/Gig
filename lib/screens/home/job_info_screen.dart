import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/secondary_button.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/checker.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Job job = Provider.of<Job>(context);
    ChatRoom chatRoom = Provider.of<ChatRoom>(context);

    void viewChatRoom() {
      var listener = {
        "name": job.job["businessName"],
        "uid": job.job["uid"],
      };

      chatRoom.open(listener);
      Navigator.pushNamed(context, "/chat/room");
    }

    void applyJob() {
      job.applyJob().then((_) {
        if (job.containsError) {
          job.showErrorMessage(context);
        }
      });
    }

    bool checkJobApplied() {
      bool havePendings = job.job["pendings"] != null ? true : false;

      if (havePendings) {
        var pendings = job.job["pendings"];
        var shortlists = job.job["shortlists"];

        if (pendings.contains(user.userId) || shortlists.contains(user.userId)) {
          return true;
        }
      } else {
        JobStatus status = Checker.getJobStatus(job.job["status"]);

        if (status == JobStatus.pending || status == JobStatus.shortlisted) {
          return true;
        }
      }

      return false;
    }

    Widget buildMessageButton() {
      bool havePendings = job.job["shortlists"] != null ? true : false;

      if (havePendings) {
        var shortlists = job.job["shortlists"];

        if (shortlists.contains(user.userId)) {
          return PrimaryButton(
            text: "Message",
            onPressed: viewChatRoom,
          );
        }
      } else {
        JobStatus status = Checker.getJobStatus(job.job["status"]);

        if (status == JobStatus.shortlisted) {
          return PrimaryButton(
            text: "Message",
            onPressed: viewChatRoom,
          );
        }
      }

      return Container();
    }

    Widget buildApplyButton() {
      if (user.userId != job.job["uid"]) {
        return SecondaryButton(
          text: checkJobApplied() ? "Applied" : "Apply Job",
          onPressed: checkJobApplied() ? null : applyJob,
        );
      }

      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Job Info"),
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        actions: <Widget>[
          RoundButton(
            icon: Icons.more_horiz,
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(job.job["businessName"]),
            Text(job.job["workPosition"]),
            buildMessageButton(),
            buildApplyButton(),
            Text(job.job["description"]),
          ],
        ),
      ),
    );
  }
}
