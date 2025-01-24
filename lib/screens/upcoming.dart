import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/allapi/allapi.dart';
import 'package:movie_app/screens/description.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpComingMovies extends StatefulWidget {
  const UpComingMovies({super.key});

  @override
  State<UpComingMovies> createState() => _UpComingMoviesState();
}

class _UpComingMoviesState extends State<UpComingMovies> {
  List<dynamic> UpComingMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUpComingChachData();
  }

  Future<void> loadUpComingChachData() async{
    final prefs =await SharedPreferences.getInstance();
    final chachedData = prefs.getString('upcoming');
    if (chachedData != null) {
      setState(() {
        UpComingMovies = jsonDecode(chachedData);
        isLoading = false;
      });
    }else{
      await UpcomingMovieData();
    }
  }

  Future<void> UpcomingMovieData() async {
    try {
      final response = await http.get(Uri.parse(upcomingmoviesurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          UpComingMovies = data['results'];
          print(UpComingMovies);
          isLoading = false;
        });
        final pref =await SharedPreferences.getInstance();
        pref.setString('upcoming', jsonEncode(UpComingMovies));
      } else {
        throw Exception('Failed to laod data ${response.statusCode}');
      }
    } catch (e) {
      print('Error accourd $e');
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
          title: Text('UpComing Movies'),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: Container(
          color: Colors.black87,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : UpComingMovies.isEmpty
                  ? Center(child: Text('No movies found'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: UpComingMovies.length,
                      itemBuilder: (context, index) {
                        final Movie = UpComingMovies[index];
                        final title = Movie['title'] ?? Movie['name'] ?? 'No Title';
                        final posterPath = 'https://image.tmdb.org/t/p/w200${Movie['backdrop_path']}';
                        final rating = Movie['popularity'];
                        final release = Movie['release_date'];
                        final review = Movie['overview'];
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
