import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DescriptionScreen extends StatelessWidget {
  final String name, Description, bannerUrl, posterUrl, vote, launch_on;

  const DescriptionScreen(
      {super.key,
      required this.name,
      required this.Description,
      required this.bannerUrl,
      required this.posterUrl,
      required this.vote,
      required this.launch_on});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: Colors.black87,
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 350,
              color: Colors.grey,
              child: Stack(
                children: [
                  Positioned(child: Container(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: posterUrl,fit: BoxFit.fill,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    ),
                  )),
                  Positioned(bottom: 5,right: 2,
                      child: Text(' Average Rating:  '+vote+'⭐',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(name,style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('Releasing on :  '+launch_on,style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),),)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    margin: EdgeInsets.all(5),
                    height: 200,
                    width: 150,
                    child: CachedNetworkImage(
                      imageUrl: posterUrl,fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  child: SingleChildScrollView(child: Center(child: Text(Description,style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),))),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
