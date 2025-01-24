import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/allapi/allapi.dart';
import 'package:movie_app/screens/allMovies.dart';
import 'package:movie_app/screens/description.dart';
import 'package:movie_app/screens/popular.dart';
import 'package:movie_app/screens/toprated.dart';
import 'package:movie_app/screens/trending.dart';
import 'package:movie_app/screens/upcoming.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> AllMovies2 = [];
  List<dynamic> trendingMovies2 = [];
  List<dynamic> popularMovies2 = [];
  List<dynamic> TopMovies2 = [];
  List<dynamic> upcomingMovies2 = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    chacheAmData();
    chacheTmData();
    chachePmData();
    chacheTopmData();
    chacheCmData();
  }

  // chaching implementation
  Future<void> chacheAmData() async{
    final prefs =await SharedPreferences.getInstance();
    final chachedData = prefs.getString('Allmovies');
    if (chachedData != null) {
      setState(() {
        AllMovies2 = jsonDecode(chachedData);
        isLoading = false;
      });
    }  else{
      await FetchAllMovieData();
    }
  }
  Future<void> chacheTmData() async{
    final prefs =await SharedPreferences.getInstance();
    final chachedData = prefs.getString('Trendingmovies');
    if (chachedData != null) {
      setState(() {
        trendingMovies2 = jsonDecode(chachedData);
        isLoading = false;
      });
    }  else{
      await FetchTrendMovieData();
    }
  }
  Future<void> chacheTopmData() async{
    final prefs =await SharedPreferences.getInstance();
    final chachedData = prefs.getString('Topmovies');
    if (chachedData != null) {
      setState(() {
        TopMovies2 = jsonDecode(chachedData);
        isLoading = false;
      });
    }  else{
      await FetchTopMovieData();
    }
  }
  Future<void> chacheCmData() async{
    final prefs =await SharedPreferences.getInstance();
    final chachedData = prefs.getString('Comingmovies');
    if (chachedData != null) {
      setState(() {
        upcomingMovies2 = jsonDecode(chachedData);
        isLoading = false;
      });
    }  else{
      await FetchComingMovieData();
    }
  }
  Future<void> chachePmData() async{
    final prefs =await SharedPreferences.getInstance();
    final chachedData = prefs.getString('Popularmovies');
    if (chachedData != null) {
      setState(() {
        popularMovies2 = jsonDecode(chachedData);
        isLoading = false;
      });
    }  else{
      await FetchPopularMovieData();
    }
  }

  // fatch data from api
  Future<void> FetchAllMovieData() async {
    try {
      final response = await http.get(Uri.parse(nowplayingmoviesurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          AllMovies2 = data['results'];
          isLoading = false;
        });
        final pref =await SharedPreferences.getInstance();
        pref.setString('Allmovies', jsonEncode(AllMovies2));
      } else {
        throw Exception('failed to load ${response.statusCode}');
      }
    } catch (e) {
      print('error $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> FetchTrendMovieData() async {
    try {
      final response = await http.get(Uri.parse(trendingweekurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          trendingMovies2 = data['results'];
          isLoading = false;
        });
        final pref =await SharedPreferences.getInstance();
        pref.setString('Trendingmovies', jsonEncode(trendingMovies2));
      } else {
        throw Exception('failed to load ${response.statusCode}');
      }
    } catch (e) {
      print('error $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> FetchPopularMovieData() async {
    try {
      final response = await http.get(Uri.parse(popularmoviesurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          popularMovies2 = data['results'];
          isLoading = false;
        });
        final pref =await SharedPreferences.getInstance();
        pref.setString('Popularmovies', jsonEncode(popularMovies2));
      } else {
        throw Exception('failed to load ${response.statusCode}');
      }
    } catch (e) {
      print('error $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> FetchTopMovieData() async {
    try {
      final response = await http.get(Uri.parse(topratedmoviesurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          TopMovies2 = data['results'];
          isLoading = false;
        });
        final pref =await SharedPreferences.getInstance();
        pref.setString('Topmovies', jsonEncode(TopMovies2));
      } else {
        throw Exception('failed to load ${response.statusCode}');
      }
    } catch (e) {
      print('error $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> FetchComingMovieData() async {
    try {
      final response = await http.get(Uri.parse(upcomingmoviesurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          upcomingMovies2 = data['results'];
          isLoading = false;
        });
        final pref =await SharedPreferences.getInstance();
        pref.setString('Comingmovies', jsonEncode(upcomingMovies2));
      } else {
        throw Exception('failed to load ${response.statusCode}');
      }
    } catch (e) {
      print('error $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.menu,
              size: 40,
            ),
            Text(
              'Flutter Movie App',
              style: TextStyle(fontSize: 20),
            ),
            Icon(
              Icons.app_registration,
              size: 30,
            )
          ],
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black87,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.black,
                height: 50,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: InkWell(
                              child: Center(
                                  child: Text(
                                'All Movies',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey, fontWeight: FontWeight.bold),
                                selectionColor: Colors.grey,
                              )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllTypeMovies(),
                                    ));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: InkWell(
                              child: Center(
                                  child: Text(
                                'Trending Movies',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey, fontWeight: FontWeight.bold),
                                selectionColor: Colors.grey,
                              )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrendingMovies(),
                                    ));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: InkWell(
                              child: Center(
                                  child: Text(
                                'Top Rated Movies',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey, fontWeight: FontWeight.bold),
                              )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TopRatedMovies(),
                                    ));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: InkWell(
                              child: Center(
                                  child: Text(
                                'UpComing Movies',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey, fontWeight: FontWeight.bold),
                              )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpComingMovies(),
                                    ));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: InkWell(
                              child: Center(
                                  child: Text(
                                'Popular Movies',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey, fontWeight: FontWeight.bold),
                              )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PoPularMovies(),
                                    ));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllTypeMovies(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'All Movies',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 250,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : AllMovies2.isEmpty
                        ? Center(
                            child: Text(
                            'No movie found',
                            style: TextStyle(color: Colors.white),
                          ))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final Movie = AllMovies2[index];
                              final Posterpath = 'https://image.tmdb.org/t/p/w200${Movie['backdrop_path']}';
                              return Container(
                                width: 150,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 250,
                                            child: CachedNetworkImage(
                                              imageUrl: Posterpath,fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://image.tmdb.org/t/p/w200$Posterpath'),
                                                    fit: BoxFit.cover),
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                    bottom: Radius.circular(20))),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DescriptionScreen(
                                                  name: Movie['title'],
                                                  bannerUrl: 'https://image.tmdb.org/t/p/w200'+Movie['backdrop_path'],
                                                  posterUrl: 'https://image.tmdb.org/t/p/w200'+Movie['poster_path'],
                                                  Description: Movie['overview'],
                                                  vote: Movie['vote_average'].toString(),
                                                  launch_on: Movie['release_date'],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ), //allmovies
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrendingMovies(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Trending',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 250,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : trendingMovies2.isEmpty
                        ? Center(
                            child: Text(
                            'No movie found',
                            style: TextStyle(color: Colors.white),
                          ))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final Movie = trendingMovies2[index];
                              final name = Movie['title'] ?? Movie['original_name'] ?? 'no title';
                              final Posterpath = 'https://image.tmdb.org/t/p/w200${Movie['poster_path']}';
                              return Container(
                                width: 150,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 250,
                                            child: CachedNetworkImage(
                                              imageUrl: Posterpath,fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://image.tmdb.org/t/p/w200$Posterpath'),
                                                    fit: BoxFit.cover),
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                    bottom: Radius.circular(20))),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context, 
                                              MaterialPageRoute(
                                                builder: (context) => DescriptionScreen(
                                                  name: name,
                                                  bannerUrl: 'https://image.tmdb.org/t/p/w200'+Movie['backdrop_path'],
                                                  posterUrl: 'https://image.tmdb.org/t/p/w200'+Movie['poster_path'],
                                                  Description: Movie['overview'],
                                                  vote: Movie['vote_average'].toString(),
                                                  launch_on: Movie['release_date'],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ), //trending
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PoPularMovies(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'PoPular',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 250,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : popularMovies2.isEmpty
                        ? Center(
                            child: Text(
                            'No movie found',
                            style: TextStyle(color: Colors.white),
                          ))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final Movie = popularMovies2[index];
                              final Posterpath = 'https://image.tmdb.org/t/p/w200${Movie['poster_path']}';
                              return Container(
                                width: 150,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 250,
                                            child: CachedNetworkImage(
                                              imageUrl: Posterpath,fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://image.tmdb.org/t/p/w200$Posterpath'),
                                                    fit: BoxFit.cover),
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                    bottom: Radius.circular(20))),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DescriptionScreen(
                                                  name: Movie['title'],
                                                  bannerUrl: 'https://image.tmdb.org/t/p/w200'+Movie['backdrop_path'],
                                                  posterUrl: 'https://image.tmdb.org/t/p/w200'+Movie['poster_path'],
                                                  Description: Movie['overview'],
                                                  vote: Movie['vote_average'].toString(),
                                                  launch_on: Movie['release_date'],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ), //popular
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopRatedMovies(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Top Rated',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 250,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : TopMovies2.isEmpty
                        ? Center(
                            child: Text(
                            'No movie found',
                            style: TextStyle(color: Colors.white),
                          ))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final Movie = TopMovies2[index];
                              final Posterpath = 'https://image.tmdb.org/t/p/w200${Movie['poster_path']}';
                              return Container(
                                width: 150,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 250,
                                            child: CachedNetworkImage(
                                              imageUrl: Posterpath,fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://image.tmdb.org/t/p/w200$Posterpath'),
                                                    fit: BoxFit.cover),
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                    bottom: Radius.circular(20))),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DescriptionScreen(
                                                  name: Movie['title'],
                                                  bannerUrl: 'https://image.tmdb.org/t/p/w200'+Movie['backdrop_path'],
                                                  posterUrl: 'https://image.tmdb.org/t/p/w200'+Movie['poster_path'],
                                                  Description: Movie['overview'],
                                                  vote: Movie['vote_average'].toString(),
                                                  launch_on: Movie['release_date'],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ), //toprated
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpComingMovies(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'UpComing',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 250,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : upcomingMovies2.isEmpty
                        ? Center(
                            child: Text(
                            'No movie found',
                            style: TextStyle(color: Colors.white),
                          ))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final Movie = upcomingMovies2[index];
                              final Posterpath = 'https://image.tmdb.org/t/p/w200${Movie['poster_path']}';
                              return Container(
                                width: 150,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 250,
                                            child: CachedNetworkImage(
                                              imageUrl: Posterpath,fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://image.tmdb.org/t/p/w200$Posterpath'),
                                                    fit: BoxFit.cover),
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                    bottom: Radius.circular(20))),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DescriptionScreen(
                                                  name: Movie['title'],
                                                  bannerUrl: 'https://image.tmdb.org/t/p/w200'+Movie['backdrop_path'],
                                                  posterUrl: 'https://image.tmdb.org/t/p/w200'+Movie['poster_path'],
                                                  Description: Movie['overview'],
                                                  vote: Movie['vote_average'].toString(),
                                                  launch_on: Movie['release_date'],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ), //upcoming
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
