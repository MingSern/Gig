import 'package:Gig/components/description_card.dart';
import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/secondary_button.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/checker.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/lorem.dart';
import 'package:Gig/utils/palette.dart';
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
      bool haveShortlists = job.job["shortlists"] != null ? true : false;

      if (haveShortlists) {
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
        centerTitle: true,
        title: Text("Job Info"),
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ProfileCard(
              fullname: job.job["businessName"],
              workPosition: job.job["workPosition"],
              onPressed: () {},
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildApplyButton(),
                buildMessageButton(),
              ],
            ),
            DescriptionCard(
              title: "Wages",
              description: job.job["wages"],
              onEdit: null,
              onDelete: null,
            ),
            DescriptionCard(
              title: "Location",
              description: job.job["location"],
              onEdit: null,
              onDelete: null,
            ),
            DescriptionCard(
              title: "Job description",
              description: Lorem.long(),
              // description: job.job["description"],
              onEdit: null,
              onDelete: null,
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String fullname;
  final String workPosition;
  final GestureTapCallback onPressed;

  ProfileCard({
    @required this.fullname,
    @required this.workPosition,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 15.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: RawMaterialButton(
        onPressed: this.onPressed,
        splashColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BuildUser(
                fullname: this.fullname,
              ),
              Container(
                child: Text(
                  this.workPosition,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 19,
                  ),
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}

class BuildUser extends StatelessWidget {
  final String fullname;

  BuildUser({
    @required this.fullname,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 35,
          backgroundColor: Palette.mustard,
          child: Text(
            Device.getFirstLetter(this.fullname),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.fullname,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            Text(
              "is offering a position for",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
