/*
*  detail_page_widget.dart
*  Movie
*
*  Created by .
*  Copyright © 2018 . All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:movie_app/data/movie_model.dart';
import 'package:movie_app/helpers/image_path_helper.dart';

class DetailPage extends StatelessWidget {
  final MovieModel movieModel;

  const DetailPage(this.movieModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.zero, bottom: Radius.circular(26)),
                  //BorderRadius.vertical
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 20.0,
                        // has the effect of softening the shadow
                        spreadRadius: 5.0,
                        // has the effect of extending the shadow
                        offset: Offset(
                          10.0, // horizontal, move right 10
                          10.0, // vertical, move down 10
                        ))
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.zero, bottom: Radius.circular(26)),
                child: Image.network(
                  buildImagePath(movieModel.posterPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 22, top: 7),
                    child: Text(
                      "IMDB 8.4",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 22, top: 9),
                    child: Text(
                      "Kong : Skull Island",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 22, top: 6),
                    child: Text(
                      "Action",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(left: 22, bottom: 5),
                    child: Text(
                      "USA, 2019",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
