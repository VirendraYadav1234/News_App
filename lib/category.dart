import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:news_app/model.dart';

class Category extends StatefulWidget {
  String Query;
  Category({required this.Query});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool isProgressbar = true;
  List<NewsQueryModel> newsModelListviren = <NewsQueryModel>[];

  bool isLoading = true;
  getNewsofIndia_viren(String query) async {
    String url =
        "newsapi.org/v2/top-headlines?country=in&apiKey=50ee36928163410f9a97abc1df72ff7b";

    if (query == " " || query == " ") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&apiKey=50ee36928163410f9a97abc1df72ff7b";
    } else {
      url =
          "https://newsapi.org/v2/everything?q=$query&from=2022-07-22&to=2022-07-22&sortBy=$query&apiKey=50ee36928163410f9a97abc1df72ff7b";
    }
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListviren.add(newsQueryModel);
        setState(() {
          isLoading = false;
          isProgressbar = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNewsofIndia_viren(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NEWS APP"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.Query,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ],
                ),
              ),
              isProgressbar
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelListviren.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        newsModelListviren[index].newsImg,
                                        height: 250,
                                        fit: BoxFit.fitHeight,
                                        width: double.infinity,
                                      )),
                                  Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newsModelListviren[index]
                                                  .newsHead
                                                  .substring(0,
                                                      30), //**********************************************
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                            // Text(
                                            //   newsModelListviren[index]
                                            //               .newsDes
                                            //               .length >
                                            //           50
                                            //       ? "${newsModelListviren[index].newsDes.substring(0, 55)}...."
                                            //       : newsModelListviren[index]
                                            //           .newsDes,
                                            //   style: TextStyle(
                                            //       color: Colors.white,
                                            //       fontSize: 12),
                                            // ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
              //******************************** show  home page *******************************
              //************************  button ****************************
              // Container(
              //   padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       ElevatedButton(onPressed: () {}, child: Text("Show more"))
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
