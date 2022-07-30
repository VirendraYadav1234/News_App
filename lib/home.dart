import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/NewsWebView.dart';
import 'package:news_app/category.dart';
import 'model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //******************** progress bar **************************
  bool isProgressBarLoading = true;
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListviren = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<String> newBarItem = [
    "Top News",
    "India",
    "World",
    "Finance",
    "Health",
    "Corona"
  ];
  //************************** API ***************************************
  bool isLoading = true;

  //**********************************************************************

  getNewsofIndia_viren(String query) async {
    Map elements;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=latest&from=2022-07-22&to=2022-07-22&sortBy=$query&apiKey=50ee36928163410f9a97abc1df72ff7b";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    setState(() {
      data["articles"].forEach((element) {
        //****************** error handling ********************
        try {
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListviren.add(newsQueryModel);
          setState(() {
            isProgressBarLoading = false;
            isLoading = false;
          });
        } catch (e) {
          print(e);
        }
      });
    });
    //****************************** short long list in sort list **********************************
    newsModelListviren.sublist(0, 15);
    // setState(() {
    //   i++;
    //   for (elements in data["articals"]) {
    //     NewsQueryModel newsQueryModel = new NewsQueryModel();
    //     newsQueryModel = NewsQueryModel.fromMap(elements);
    //     newsModelListviren.add(newsQueryModel);
    //     setState(() {
    //       isProgressBarLoading = false;
    //       isLoading = false;
    //     });
    //     if (i == 10) {
    //       break;
    //     }
    //   };
    // });

    //**************************** for sort data *************************
    //              newsModelListviren.sublist(0,20);
  }

  getNewsofIndia() async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=50ee36928163410f9a97abc1df72ff7b";
    // "https://newsapi.org/v2/everything?q=apple&from=2022-07-22&to=2022-07-22&sortBy=popularity&apiKey=50ee36928163410f9a97abc1df72ff7b";
    //"https://newsapi.org/v2/top-headlines?country=IN&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() {
            isLoading = false;
            isProgressBarLoading = false;
          });
        } catch (e) {
          print(e);
        }
      });
    });
  }
  //******************************************************************************************************

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsofIndia();
    getNewsofIndia_viren("Latestnews");
  }
  //************************** API ***************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New News"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //********************** Search container ***************************
              //color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("blank search");
                      } else {
                        //thor search data in category page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Category(Query: searchController.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      //thor search data in category page throw keybord

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category(Query: value)));

                      //print(searchController.text);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search  ",
                    ),
                  ))
                ],
              ),
            ),
            //******************************* Search container ***************************
            //******************************* Toggle button  InkWell ***************************
            Container(
              height: 50,
              child: isProgressBarLoading
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: newBarItem.length,
                      itemBuilder: (context, index) {
                        // inkweall for click
                        return InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsView(newBarItem[index].ap)))

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Category(
                                          Query: newBarItem[index],
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                newBarItem[index],
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }),
            ),

            //******************************** Toggle button *****************************************

            //******************************** Slide show  *****************************************

            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: CarouselSlider(
                  items: newsModelListCarousel.map((instance) {
                    return Builder(builder: (BuildContext context) {
                      try {
                        return Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewsView(instance.newsUrl)));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      instance.newsImg,
                                      fit: BoxFit.fitHeight,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 8),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              instance.newsHead,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      } catch (e) {
                        print(e);
                        return Container();
                      }
                    });
                  }).toList(),
                  options: CarouselOptions(
                      height: 200, autoPlay: true, enlargeCenterPage: true)),
            )
            //******************************** Slide show  *****************************************
            ,

            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Latest news",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            SizedBox(
                              height: 0,
                              width: 25,
                            ),
                            Text(
                              "created by virendra",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.blueAccent),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  isProgressBarLoading
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: newsModelListviren.length,
                          itemBuilder: (context, index) {
                            try {
                              return SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      //************** open news website here *****************************
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewsView(
                                                  newsModelListviren[index]
                                                      .newsUrl)));
                                    },
                                    child: Card(
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                newsModelListviren[index]
                                                    .newsImg,
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
                                                        BorderRadius.circular(
                                                            15),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black12
                                                              .withOpacity(0),
                                                          Colors.black
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter)),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
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
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                ),
                              );
                            } catch (e) {
                              print(e);
                              return Container();
                            }
                          }),
                  //******************************** show  home page *******************************
                  //************************  button ****************************
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Category(Query: "Technology")));
                            },
                            child: Text("Show more"))
                      ],
                    ),
                  )
                ],
              ),
            ),
            //******************************** show  home page *****************************************
          ],
        ),
      ),
    );
  }

  final List iteams = [Colors.blueAccent, Colors.orange, Colors.red];
}
