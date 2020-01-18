import 'package:Gig/components/round_button.dart';
import 'package:Gig/utils/device.dart';
import 'package:flutter/material.dart';

class SearchJobsScreen extends StatefulWidget {
  @override
  _SearchJobsScreenState createState() => _SearchJobsScreenState();
}

class _SearchJobsScreenState extends State<SearchJobsScreen> {
  String keyword;
  final TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: RoundButton(
          icon: Icons.arrow_back,
          onPressed: () {
            Device.dismissKeyboard(context);
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: this.searchBar(),
      ),
    );
  }

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
              onChanged: (value) {
                setState(() {
                  keyword = value;
                });
              },
            ),
          ),
          keyword != ""
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      textController.clear();
                      keyword = "";
                    });
                  },
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
}
