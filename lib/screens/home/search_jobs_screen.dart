import 'package:Gig/components/empty_state.dart';
import 'package:Gig/components/round_button.dart';
import 'package:Gig/components/small_card.dart';
import 'package:Gig/models/image_manager.dart';
import 'package:Gig/models/job.dart';
import 'package:Gig/utils/algorithm.dart';
import 'package:Gig/utils/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchJobsScreen extends StatefulWidget {
  @override
  _SearchJobsScreenState createState() => _SearchJobsScreenState();
}

class _SearchJobsScreenState extends State<SearchJobsScreen> {
  bool searching = false;
  TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = new TextEditingController(text: "");
    textController.addListener(() {
      setState(() {
        searching = textController.text != "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageManager imageManager = Provider.of<ImageManager>(context);
    Job job = Provider.of<Job>(context);

    Widget searchBar() {
      return Container(
        height: 40,
        alignment: Alignment(0, 0),
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search jobs",
                ),
              ),
            ),
            this.searching
                ? GestureDetector(
                    onTap: textController.clear,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.clear,
                        color: Colors.black87,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }

    void viewJobInfo(document) {
      job.setJob(document);
      Navigator.pushNamed(context, "/home/job/info");
    }

    List<DocumentSnapshot> filterDocument() {
      return job.availableJobs.where((document) {
        if (document["uid"] != null) {
          imageManager.addAccountId(document["uid"]);
        }

        var keyword = textController.text.toLowerCase().replaceAll(" ", "");
        return Algorithm.search(document: document, keyword: keyword);
      }).toList();
    }

    List<Widget> mapDocuments() {
      List<DocumentSnapshot> filteredDocument = filterDocument();

      if (filteredDocument.isEmpty) {
        return [
          Container(
            height: Device.getMaxHeight(context) * 0.4,
            child: Center(
              child: Text("No result"),
            ),
          )
        ];
      }

      return filteredDocument.map((document) {
        return SmallCard(
          workPosition: document["workPosition"],
          businessName: document["businessName"],
          imageUrl: imageManager.getImageUrl(document["uid"]),
          wages: document["wages"],
          createdAt: document["createdAt"],
          location: document["location"],
          onPressed: () => viewJobInfo(document),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        titleSpacing: 0,
        title: searchBar(),
      ),
      body: textController.text == ""
          ? ListView(
              children: <Widget>[
                EmptyState(
                  imagePath: "assets/empty_search.png",
                  message: "You can search jobs by the business name 💼, work position 👷 or location 📍",
                ),
              ],
            )
          : ListView(children: mapDocuments()),
    );
  }
}
