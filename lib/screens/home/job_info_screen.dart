import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/secondary_button.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
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
      if (job.job["appliedBy"] == null) {
        return true;
      } else if (job.job["appliedBy"].contains(job.userId)) {
        return true;
      }

      return false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            user.userId != job.job["uid"]
                ? PrimaryButton(
                    text: "Message",
                    onPressed: viewChatRoom,
                  )
                : Container(),
            user.userId != job.job["uid"]
                ? SecondaryButton(
                    text: checkJobApplied() ? "Applied" : "Apply Job",
                    onPressed: checkJobApplied() ? null : applyJob,
                  )
                : Container(),
            Text(job.job["description"]),
          ],
        ),
      ),
    );
  }
}
