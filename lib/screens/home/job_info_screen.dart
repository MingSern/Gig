import 'dart:ui';
import 'package:Gig/components/description_card.dart';
import 'package:Gig/components/primary_button.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/secondary_button.dart';
import 'package:Gig/enum/enum.dart';
import 'package:Gig/models/chat_room.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/models/user.dart';
import 'package:Gig/utils/checker.dart';
import 'package:Gig/utils/device.dart';
import 'package:Gig/utils/dialogs.dart';
import 'package:Gig/utils/generator.dart';
import 'package:Gig/utils/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobInfoScreen extends StatelessWidget {
  final imageUrl = Generator.getImageUrl();

  @override
  Widget build(BuildContext context) {
    ImageManager imageManager = Provider.of<ImageManager>(context);
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
      if (user.profileCompleted) {
        job.applyJob().then((_) {
          if (job.containsError) {
            job.showErrorMessage(context);
          }
        });
      } else {
        Dialogs.notifyDialog(
          context: context,
          content:
              "Before you can apply for a job, make sure you have added some descriptions on your profile.",
        );
      }
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
          smaller: true,
          text: checkJobApplied() ? "Applied" : "Apply Job",
          loading: job.loading,
          onPressed: checkJobApplied() ? null : applyJob,
        );
      }

      return Container();
    }

    void viewProfile(String uid) {
      user.viewOtherUserProfile(uid);
      Navigator.pushNamed(context, "/profile/view");
    }

    void onDelete() {
      Dialogs.confirmationDialog(
        context: context,
        title: "Delete",
        content: "Are you sure you want to delete this job?",
        onConfirm: "Delete",
      ).then((onConfirm) {
        if (onConfirm ?? false) {
          job.deleteJob(job.job["key"]).then((_) {
            Navigator.pop(context);
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Job Info"),
        leading: RoundButton(
          icon: Icons.arrow_back,
          loading: job.loading,
          onPressed: () => Device.goBack(context),
        ),
        actions: <Widget>[
          job.job["uid"] == user.userId
              ? RoundButton(
                  icon: Icons.delete_outline,
                  loading: job.loading,
                  onPressed: onDelete,
                )
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 70),
                  height: Device.getMaxHeight(context) * 0.4,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: job.job["imageUrls"]?.first ?? this.imageUrl,
                    fadeOutCurve: Curves.easeIn,
                    fadeInDuration: Duration(milliseconds: 500),
                    fit: BoxFit.cover,
                  ),
                ),
                ProfileCard(
                  fullname: job.job["businessName"],
                  imageUrl: job.job["uid"] == user.userId
                      ? user.account.imageUrl
                      : imageManager.getImageUrl(job.job["uid"]),
                  workPosition: job.job["workPosition"],
                  onPressed: job.job["uid"] == user.userId ? null : () => viewProfile(job.job["uid"]),
                ),
              ],
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
              icon: Icons.category,
              title: "Category",
              child: Text(job.job["category"]),
            ),
            DescriptionCard(
              icon: Icons.monetization_on,
              title: "Wages",
              child: Text("RM ${job.job["wages"]}/hr"),
            ),
            DescriptionCard(
              icon: Icons.accessibility_new,
              title: "Preferred age",
              child: Text(job.job["age"]),
            ),
            DescriptionCard(
              icon: Icons.person,
              title: "Preferred gender",
              child: Text(job.job["gender"]),
            ),
            DescriptionCard(
              icon: Icons.location_on,
              title: "Location",
              child: Text(job.job["location"]),
            ),
            DescriptionCard(
              icon: Icons.description,
              title: "Job description",
              child: Text(job.job["description"]),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String fullname;
  final String imageUrl;
  final String workPosition;
  final GestureTapCallback onPressed;

  ProfileCard({
    @required this.fullname,
    @required this.imageUrl,
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
                imageUrl: this.imageUrl,
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
  final String imageUrl;

  BuildUser({
    @required this.fullname,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Widget handleAvatar() {
      if (this.imageUrl?.isNotEmpty ?? false) {
        if (this.imageUrl != "null") {
          // return CircleAvatar(
          //   radius: 35,
          //   backgroundColor: Colors.grey[100],
          //   backgroundImage: CachedNetworkImageProvider(this.imageUrl),
          // );
          return Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: this.imageUrl,
                fadeOutCurve: Curves.easeIn,
                fadeInDuration: Duration(milliseconds: 500),
              ),
            ),
          );
        }
      }

      return CircleAvatar(
        radius: 35,
        backgroundColor: Palette.mustard,
        child: Text(
          Device.getFirstLetter(this.fullname),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Row(
      children: <Widget>[
        handleAvatar(),
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
