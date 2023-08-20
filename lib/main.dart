import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_api_test/models/articles.dart';
import 'package:news_api_test/models/sources.dart';
import 'package:news_api_test/pages/detail.dart';
import 'package:news_api_test/service/api.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:news_api_test/routers/route.dart' as router;
import 'package:localstorage/localstorage.dart';
import 'package:skeletons/skeletons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkVersion = androidInfo.version.sdkInt ?? 0;
  final androidOverscrollIndicator = sdkVersion > 30
      ? AndroidOverscrollIndicator.stretch
      : AndroidOverscrollIndicator.glow;

  runApp(MyApp(
    androidOverscrollIndicator: androidOverscrollIndicator,
  ));
}

class MyApp extends StatelessWidget {
  final AndroidOverscrollIndicator androidOverscrollIndicator;
  const MyApp({
    Key? key,
    this.androidOverscrollIndicator = AndroidOverscrollIndicator.glow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEWS APP',
      theme: ThemeData(
        androidOverscrollIndicator: androidOverscrollIndicator,
        primarySwatch: Colors.indigo,
      ),
      onGenerateRoute: router.generateRoute,
      home: const MyHomePage(title: 'NEWS APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalStorage storage = LocalStorage('news_app');
  Future<ArticleRes>? _futureArticle;
  List<ArticleData>? articleData;
  List<ArticleData>? articleDataOriginal;
  List<String> categories = [
    "All Categories",
    "Business",
    "Entertainment",
    "General",
    "Health",
    "Science",
    "Sports",
    "Technology"
  ];

  Future<SourcesRes>? _futureSources;
  List<SourceData>? sourcesData;
  List<SourceData>? sourcesDataOriginal;

  TextEditingController? searchTextSources;
  TextEditingController? searchTextArticle;

  bool searchSources = true;
  bool searchArticle = true;

  String? selectedSources;
  String? selectedCategories;
  @override
  void initState() {
    _futureArticle = ApiService().getArticle();
    _futureArticle?.then((value) {
      if (value.status == "ok") {
        setState(() {
          articleData = value.articles;
          articleDataOriginal = value.articles;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value.status.toString()),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    });
    _futureSources = ApiService().getSource("All Categories");
    _futureSources?.then((value) {
      if (value.status == "ok") {
        setState(() {
          sourcesData = value.sources;
          sourcesDataOriginal = value.sources;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value.status.toString()),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "Categories",
          //     style: TextStyle(fontSize: 18),
          //   ),
          // ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((e) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCategories = e;
                    });
                    _futureSources = ApiService().getSource(e);
                    _futureSources?.then((value) {
                      if (value.status == "ok") {
                        setState(() {
                          sourcesData = value.sources;
                          sourcesDataOriginal = value.sources;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(value.status.toString()),
                          ),
                        );
                      }
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    });
                    _futureArticle = ApiService().getArticle();
                    _futureArticle?.then((value) {
                      if (value.status == "ok") {
                        setState(() {
                          articleData = value.articles;
                          articleDataOriginal = value.articles;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(value.status.toString()),
                          ),
                        );
                      }
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    });
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(
                      right: 6.0,
                      left: 6.0,
                      top: 6.0,
                      bottom: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: e == selectedCategories
                          ? Colors.indigo
                          : Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        e,
                        style: TextStyle(
                          color: e == selectedCategories
                              ? Colors.white
                              : Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Sources",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                // SearchBar(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: searchSources
                        ? TextField(
                            controller: searchTextSources,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  sourcesData = sourcesDataOriginal;
                                });
                              } else {
                                setState(() {
                                  sourcesData = sourcesDataOriginal
                                      ?.where((element) => element.name!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // suffixIcon: IconButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       searchTextSources?.value = TextEditingValue(
                              //           text: "",
                              //           selection:
                              //               TextSelection.collapsed(offset: 0));
                              //     });
                              //   },
                              //   icon: Icon(Icons.close),
                              // ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                maxWidth: 50,
                                maxHeight: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchSources = !searchSources;
                                });
                              },
                              icon: Icon(Icons.search),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
          //
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Skeleton(
              isLoading: sourcesData == null,
              skeleton: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(
                      right: 6.0,
                      left: 6.0,
                      top: 6.0,
                      bottom: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: sourcesData?.map((e) {
                      return InkWell(
                        hoverColor: Colors.indigo.shade50,
                        splashColor: Colors.indigo.shade50,
                        highlightColor: Colors.indigo.shade50,
                        focusColor: Colors.indigo.shade50,
                        onTap: () {
                          setState(() {
                            selectedSources = e.id;
                          });
                          _futureArticle =
                              ApiService().getArticle(source: e.id);
                          _futureArticle?.then((value) {
                            if (value.status == "ok") {
                              setState(() {
                                articleData = value.articles;
                                articleDataOriginal = value.articles;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value.status.toString()),
                                ),
                              );
                            }
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
                            );
                          });
                        },
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.only(
                            right: 6.0,
                            left: 6.0,
                            top: 6.0,
                            bottom: 6.0,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: 120,
                            maxHeight: 50,
                          ),
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: e.id == selectedSources
                                ? Colors.indigo
                                : Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              e.name.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: e.id == selectedSources
                                    ? Colors.white
                                    : Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList() ??
                    [],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Articles",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                // SearchBar(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: searchArticle
                        ? TextField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  articleData = articleDataOriginal;
                                });
                              } else {
                                setState(() {
                                  articleData = articleDataOriginal
                                      ?.where((element) => element.title!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // suffixIcon: IconButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       searchArticle = !searchArticle;
                              //     });
                              //   },
                              //   icon: Icon(Icons.close),
                              // ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                maxWidth: 50,
                                maxHeight: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchArticle = !searchArticle;
                                });
                              },
                              icon: Icon(Icons.search),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Skeleton(
              isLoading: articleData == null ? true : false,
              child: ListView.builder(
                itemCount: articleData?.length,
                // padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DetailNews.routeName,
                        arguments: articleData![index],
                      );
                    },
                    trailing: InkWell(
                      onTap: () {
                        if (storage.getItem(
                                articleData![index].title.toString()) ==
                            null) {
                          setState(() {
                            storage.setItem(
                              articleData![index].title.toString(),
                              articleData![index],
                            );
                          });
                        } else {
                          setState(() {
                            storage.deleteItem(
                                articleData![index].title.toString());
                          });
                        }
                      },
                      child: storage.getItem(
                                articleData![index].title.toString(),
                              ) ==
                              null
                          ? Icon(
                              Icons.favorite,
                              color: Colors.grey,
                              size: 20,
                            )
                          : Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                    ),
                    title: Text(
                      articleData![index].title.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    subtitle: Text(
                      articleData![index].description ?? "-",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    leading: articleData![index].urlToImage == null
                        ? Image.asset(
                            'images/no-data.png',
                            width: 100,
                            height: 100,
                          )
                        : Image.network(
                            articleData![index].urlToImage.toString(),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                  );
                },
              ),
              skeleton: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                    title: Container(
                      width: 200,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                    subtitle: Container(
                      width: 200,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // articleData == null
          //     ? const Divider()
          //     : Expanded(
          //         child: ListView.builder(
          //           itemCount: articleData?.length,
          //           // padding: const EdgeInsets.all(8.0),
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               onTap: () {
          //                 Navigator.pushNamed(
          //                   context,
          //                   DetailNews.routeName,
          //                   arguments: articleData![index],
          //                 );
          //               },
          //               trailing: InkWell(
          //                 onTap: () {
          //                   if (storage.getItem(
          //                           articleData![index].title.toString()) ==
          //                       null) {
          //                     setState(() {
          //                       storage.setItem(
          //                         articleData![index].title.toString(),
          //                         articleData![index],
          //                       );
          //                     });
          //                   } else {
          //                     setState(() {
          //                       storage.deleteItem(
          //                           articleData![index].title.toString());
          //                     });
          //                   }
          //                 },
          //                 child: storage.getItem(
          //                           articleData![index].title.toString(),
          //                         ) ==
          //                         null
          //                     ? Icon(
          //                         Icons.favorite,
          //                         color: Colors.grey,
          //                         size: 20,
          //                       )
          //                     : Icon(
          //                         Icons.favorite,
          //                         color: Colors.red,
          //                         size: 20,
          //                       ),
          //               ),
          //               title: Text(
          //                 articleData![index].title.toString(),
          //                 overflow: TextOverflow.ellipsis,
          //                 maxLines: 2,
          //               ),
          //               subtitle: Text(
          //                 articleData![index].description ?? "-",
          //                 overflow: TextOverflow.ellipsis,
          //                 maxLines: 2,
          //               ),
          //               leading: articleData![index].urlToImage == null
          //                   ? Image.asset(
          //                       'images/no-data.png',
          //                       width: 100,
          //                       height: 100,
          //                     )
          //                   : Image.network(
          //                       articleData![index].urlToImage.toString(),
          //                       fit: BoxFit.cover,
          //                       width: 100,
          //                       height: 100,
          //                     ),
          //             );
          //           },
          //         ),
          //       ),
          const SizedBox(height: 5),
        ],
      ),
      // AnimatedSwitcher(
      //   duration: const Duration(milliseconds: 500),
      //   child: articleData == null
      //       ? const Center(
      //           child: Text("No Data"),
      //         )
      //       : ListView.builder(
      //           itemCount: articleData?.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               title: Text(articleData![index].title.toString()),
      //               subtitle: Text(articleData![index].description.toString()),
      //               leading: Image.network(
      //                 articleData![index].urlToImage.toString(),
      //                 fit: BoxFit.cover,
      //                 width: 100,
      //                 height: 100,
      //               ),
      //             );
      //           },
      //         ),
      // ),
    );
  }
}
