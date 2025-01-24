import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/allapi/allapi.dart';
import 'package:movie_app/screens/description.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrendingMovies extends StatefulWidget {
  const TrendingMovies({super.key});

  @override
  State<TrendingMovies> createState() => _TrendingMoviesState();
}

class _TrendingMoviesState extends State<TrendingMovies> {
  List<dynamic> TrendingList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCahchedTrendingData();
  }

  Future<void> loadCahchedTrendingData() async{
    final pref = await SharedPreferences.getInstance();
    final chachedData = pref.getString('trending');
    print(chachedData);
    if (chachedData != null) {
      setState(() {
        TrendingList = jsonDecode(chachedData);
        print(TrendingList);
        isLoading = false;
      });
    }  else{
      await TrendingMovieData();
    }
  }

  Future<void> TrendingMovieData() async {
    try {
      final response = await http.get(Uri.parse(trendingweekurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('data : $data');
        setState(() {
          TrendingList = data['results'] as List<dynamic>;
          isLoading = false;
        });
        final prefs =await SharedPreferences.getInstance();
        prefs.setString('trending', jsonEncode(TrendingList));
      } else {
        throw Exception('Failed to laod data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Data: $e');
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
          title: Text('Trending Movies'),
          backgroundColor: Colors.brown,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.black87,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : TrendingList.isEmpty
                  ? Center(child: Text('No Movie found'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: TrendingList.length,
                      itemBuilder: (context, index) {
                        final Movie = TrendingList[index];
                        final title = Movie['title'] ?? Movie['name'] ?? 'No Title';
                        final posterPath = 'https://image.tmdb.org/t/p/w500${Movie['backdrop_path']}';
                        final rating = Movie['popularity'] / 1000 * 10.toInt();
                        final release = Movie['release_date'];
                        final review = Movie['overview'];
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: CachedNetworkImage(
                                  imageUrl: posterPath,fit: BoxFit.fill,repeat: ImageRepeat.noRepeat,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DescriptionScreen(
                                        name: title,
                                        bannerUrl: 'https://image.tmdb.org/t/p/w200'+Movie['backdrop_path'],
                                        posterUrl: 'https://image.tmdb.org/t/p/w200'+Movie['poster_path'],
                                        Description: Movie['overview'],
                                        vote: Movie['vote_average'].toString(),
                                        launch_on: Movie['release_date'],
                                      ),
                                ));
                          },
                        );
                      },
                    ),
        ));
  }
}
