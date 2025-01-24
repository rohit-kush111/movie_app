import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/allapi/allapi.dart';
import 'package:movie_app/screens/description.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({super.key});

  @override
  State<TopRatedMovies> createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
  List<dynamic> TopMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCahchedTopRatedData();
  }

  Future<void> loadCahchedTopRatedData() async{
    final pref = await SharedPreferences.getInstance();
    final chachedData = pref.getString('topRated');
    print(chachedData);
    if (chachedData != null) {
      setState(() {
        TopMovies = jsonDecode(chachedData);
        print(TopMovies);
        isLoading = false;
      });
    }  else{
      await TopratedMovieData();
    }
  }

  Future<void> TopratedMovieData() async {
    try {
      final response = await http.get(Uri.parse(topratedmoviesurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          TopMovies = data['results'];
          isLoading = false;
        });
        final prefs =await SharedPreferences.getInstance();
        prefs.setString('topRated', jsonEncode(TopMovies));
      } else {
        throw Exception('error accor ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load movies $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TopRated Movies'),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: Container(
          color: Colors.black87,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : TopMovies.isEmpty
                  ? Center(child: Text('No movie found'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: TopMovies.length,
                      itemBuilder: (context, index) {
                        final Movie = TopMovies[index];
                        final title = Movie['title'] ?? Movie['original_language'] ?? 'No Title';
                        final posterPath = 'https://image.tmdb.org/t/p/w200${Movie['backdrop_path']}';
                        final rating = Movie['popularity'];
                        final release = Movie['release_date'];
                        final review = Movie['overview'];
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child:  CachedNetworkImage(
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
                                        name: Movie['title'],
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
