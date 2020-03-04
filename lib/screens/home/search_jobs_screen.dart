import 'package:Gig/components/round_button.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';

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
      if (textController.text != "") {
        setState(() {
          searching = true;
        });
      } else {
        setState(() {
          searching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar() {
      return Container(
        height: 40,
        alignment: Alignment(0, 0),
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () => Device.goBack(context),
        ),
        titleSpacing: 0,
        title: searchBar(),
      ),
      body: Container(),
    );
  }
}
