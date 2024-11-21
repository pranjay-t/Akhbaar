import 'dart:convert';
import 'package:akhbaar/model.dart';
import 'package:akhbaar/category.dart';
import 'package:akhbaar/view.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<NewsQueryModel> modelList = <NewsQueryModel>[];
  List<NewsQueryModel> modelListCarousal = <NewsQueryModel>[];
  List<String> navBarItem = [
    "Tech",
    "India",
    "Finance",
    "Anime",
    "World",
    "Sports"
  ];
  bool isLoading = true;
  getNews() async {
    String url =
        "https://newsapi.org/v2/everything?domains=aajtak.in&apiKey=372aa90d06e747928c013d4d12eb73e0";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(
      () {
        data["articles"].forEach((element) {
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          modelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
        });
      },
    );
  }

  getNewsIndia() async {
    String url =
        "https://newsapi.org/v2/everything?domains=screenrant.com&language=en&apiKey=372aa90d06e747928c013d4d12eb73e0";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        modelListCarousal.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
    getNewsIndia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(
          child: Text(
            "Akhbaar",
            style: TextStyle(
                fontFamily: "Erode",
                fontWeight: FontWeight.w500,
                decorationColor: Colors.black,
                decoration: TextDecoration.underline,
                fontSize: 60),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(children: [
            Container(
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if ((searchController.text).replaceAll(" ", "") == "") {}
                          else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Category(query1: value)));}
                        },
                        controller: searchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "What are you looking for ?",
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {}
                        else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Category(query1: searchController.text)));
                        }
                      },
                      child: const Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                        size: 35,
                      ),
                    )
                  ],
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navBarItem.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Category(query1: navBarItem[index])));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 38),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: colorsItems[index],
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              navBarItem[index],
                              style: const TextStyle(
                                fontSize: 40,
                                fontFamily: "Erode",
                                fontWeight: FontWeight.w500,
                                decorationColor: Colors.white,
                                decoration: TextDecoration.underline,
                                // fontFamily: "Titlin",
                                // fontWeight:FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 17,
            ),
            Container(
                child: isLoading
                    ? const SizedBox(
                        height: 220,
                        child: Center(child: CircularProgressIndicator()))
                    : CarouselSlider(
                        options: CarouselOptions(
                          height: 220,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          animateToClosest: true,
                        ),
                        items: modelListCarousal.map((instance) {
                          return Builder(builder: (BuildContext context) {
                            try {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsView(instance.newsUrl)));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          instance.newsImg,
                                          fit: BoxFit.fitHeight,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black54
                                                        .withOpacity(0.2),
                                                    Colors.black87
                                                        .withOpacity(0.5),
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Text(
                                            instance.newsHead.length > 50
                                                ? "${instance.newsHead.substring(0, 50)}..."
                                                : instance.newsHead,
                                            style: const TextStyle(
                                              fontFamily: "Titlin",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } catch (e) {
                              return Container();
                            }
                          });
                        }).toList(),
                      )),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Container(
                  child: const Text(
                    "LATEST NEWS",
                    style: TextStyle(
                      fontSize: 70,
                      fontFamily: "Erode",
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      color: Colors.white,
                    ),
                  ),
                ),
                isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height - 450,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: modelList.length,
                        itemBuilder: (context, index) {
                          try {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsView(modelList[index].newsUrl)));
                              },
                              child: Container(
                                margin: const EdgeInsets.all(7),
                                child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Stack(children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              modelList[index].newsImg,
                                              fit: BoxFit.fitHeight,
                                              width: double.infinity,
                                              height: 230,
                                            )),
                                        Positioned(
                                          left: 0,
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black54
                                                          .withOpacity(0.1)
                                                          .withOpacity(0.2),
                                                      Colors.black54
                                                          .withOpacity(0.5),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  modelList[index]
                                                              .newsHead
                                                              .length >
                                                          50
                                                      ? "${modelList[index].newsHead.substring(0, 50)}..."
                                                      : modelList[index].newsHead,
                                                  style: const TextStyle(
                                                    fontFamily: "Titlin",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  modelList[index]
                                                              .newsDes
                                                              .length >
                                                          50
                                                      ? "${modelList[index].newsDes.substring(0, 50)}..."
                                                      : modelList[index].newsDes,
                                                  style: const TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } catch (e) {
                            return Container();
                          }
                        }),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Category(query1: "Latest News")));
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.grey),
                ),
                child: const Text(
                  "Show More",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                      fontSize: 20),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  List colorsItems = [
    Colors.deepOrangeAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.purpleAccent,
    Colors.amber,
    Colors.redAccent,
  ];
}
