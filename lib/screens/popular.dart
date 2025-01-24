import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/allapi/allapi.dart';
import 'package:movie_app/screens/description.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoPularMovies extends StatefulWidget {
  const PoPularMovies({super.key});

  @override
  State<PoPularMovies> createState() => _PoPularMoviesState();
}

class _PoPularMoviesState extends State<PoPularMovies> {
  List<dynamic> PoPularMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPopularChacheData();
  }

  Future<void> loadPopularChacheData() async{
    final prefs =await SharedPreferences.getInstance();
    final chacheData = prefs.getString('popular');
    if (chacheData != null) {
      setState(() {
        PoPularMovies = jsonDecode(chacheData);
        isLoading = false;
      });
    } else{
      await PopularMoviesData();
    }
  }

  // fatch the data from api
  Future<void> PopularMoviesData() async {
    try {
      final responsne = await http.get(Uri.parse(popularmoviesurl));
      if (responsne.statusCode == 200) {
        final data = jsonDecode(responsne.body);
        setState(() {
          PoPularMovies = data['results'];
          isLoading = false;
        });
        //to save the data in chache
        final pref =await SharedPreferences.getInstance();
        pref.setString('popular', jsonEncode(PoPularMovies));
      } else {
        throw Exception('failed to load ${responsne.statusCode}');
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
          title: Text('Popular Movies'),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: Container(
          color: Colors.black87,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : PoPularMovies.isEmpty
                  ? Center(child: Text('No movies found'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: PoPularMovies.length,
                      itemBuilder: (context, index) {
                        final Movie = PoPularMovies[index];
                        final title = Movie['title'] ?? Movie['name'] ?? 'No Title';
                        final posterPath = 'https://image.tmdb.org/t/p/w200${Movie['backdrop_path']}';
                        final rating = Movie['popularity'];
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
