import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/allapi/allapi.dart';
import 'package:movie_app/screens/description.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllTypeMovies extends StatefulWidget {
  const AllTypeMovies({super.key});

  @override
  State<AllTypeMovies> createState() => _AllTypeMoviesState();
}

class _AllTypeMoviesState extends State<AllTypeMovies> {
  List<dynamic> AllMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCahchedAllMoviesData();
  }

  Future<void> loadCahchedAllMoviesData() async{
    final pref = await SharedPreferences.getInstance();
    final chachedData = pref.getString('allmovies');
    print(chachedData);
    if (chachedData != null) {
      setState(() {
        AllMovies = jsonDecode(chachedData);
        print(AllMovies);
        isLoading = false;
      });
    }  else{
      await AllMoviesData();
    }
  }

  Future<void> AllMoviesData() async {
    try {
      final responsne = await http.get(Uri.parse(nowplayingmoviesurl));
      if (responsne.statusCode == 200) {
        final data = jsonDecode(responsne.body);
        setState(() {
          AllMovies = data['results'] as List<dynamic>;
          isLoading = false;
        });
        final prefs =await SharedPreferences.getInstance();
        prefs.setString('allmovies', jsonEncode(AllMovies));
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
          title: Text('All Movies'),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: Container(
          color: Colors.black87,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : AllMovies.isEmpty
                  ? Center(child: Text('No movies found'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: AllMovies.length,
                      itemBuilder: (context, index) {
                        final Movie = AllMovies[index];
                        final title = Movie['title'] ?? Movie['name'] ?? 'No Title';
                        final posterPath = 'https://image.tmdb.org/t/p/w200${Movie['backdrop_path']}';
                        final rating = Movie['popularity'];
                        final release = Movie['release_date'];
                        final review = Movie['overview'];
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
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
                        );
                      },
                    ),
        ));
  }
}
