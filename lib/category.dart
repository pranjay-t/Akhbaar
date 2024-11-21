import 'dart:convert';
import 'package:akhbaar/view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:akhbaar/model.dart';

class Category extends StatefulWidget {
  final String query1;
  Category({required this.query1});
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> modelListCategory = <NewsQueryModel>[];
  bool isLoading = true;
  getCategoryNews(String query) async {
    String url =
        "https://newsapi.org/v2/everything?qInTitle=%22$query%22&language=en&sortBy=publishedAt&apiKey=372aa90d06e747928c013d4d12eb73e0";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        modelListCategory.add(newsQueryModel);
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
    getCategoryNews(widget.query1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Akhbaar",style: TextStyle(
                fontFamily: "Erode",
                fontWeight: FontWeight.w500,
                decorationColor: Colors.black,
                decoration: TextDecoration.underline,
                fontSize: 50
            ),),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.black,
              child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Row(
                            children: [
                              const Text(
                                "Showing results for ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                widget.query1,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: modelListCategory.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsView(modelListCategory[index].newsUrl)));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(7),
                                  child: Column(
                                    children: [
                                      Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color:Colors.grey,
                                          ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                        ),
                                        child: Stack(children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                modelListCategory[index].newsImg,
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
                                                            .withOpacity(0.3),
                                                        Colors.black.withOpacity(0.8),
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
                                                    modelListCategory[index]
                                                                .newsHead
                                                                .length >
                                                            50
                                                        ? "${modelListCategory[index].newsHead.substring(0, 50)}..."
                                                        : modelListCategory[index]
                                                            .newsHead,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    modelListCategory[index]
                                                                .newsDes
                                                                .length >
                                                            50
                                                        ? "${modelListCategory[index].newsDes.substring(0, 50)}..."
                                                        : modelListCategory[index]
                                                            .newsDes,
                                                    style: const TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                        color: Colors.white,
                                                        fontSize: 14),
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
                            }),

                      ],
                    ),
            ),
          )),
      if (isLoading)
        const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
      if(isLoading)
      const Center(
        child: CircularProgressIndicator(),
      ),
    ]);
  }
}
