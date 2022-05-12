import 'package:catalogo_filmes/models/favorites.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_filmes/models/movie.dart';
import 'package:catalogo_filmes/models/genre.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List _items = [];
  List _genreList = [];

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/my_genre_data.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["genres"];
      for (var genre in _items) {
        _genreList.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)?.settings.arguments as Movie;
    String movieTitle = movie.title as String;
    String posterPath = movie.posterPath as String;
    String releaseDate = movie.releaseDate as String;
    String ano = releaseDate.substring(0, 4);
    String overview = movie.overview as String;
    num? rate = movie.voteAverage;
    List<int> genres = movie.genreIds!;
    int percentual = (rate! * 10).toInt();
    List<String> genresNames = [];

    bool isFavorite = false;

    setState(() {
      for (var movieGenre in genres) {
        for (var genre in _genreList) {
          if (movieGenre == genre['id']) {
            genresNames.add(genre['name']);
          }
        }
      }
    });

    _favoriteHanler() {
      setState(() {});
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              Consumer<Favorites>(
                builder: (context, icon, child) {
                  isFavorite = icon.favoriteMovies.contains(movie);
                  return (isFavorite
                      ? GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                isFavorite = false;
                                icon.removeFavoriteMovie(movie);
                              },
                            );
                          },
                          child: Icon(
                            Icons.favorite,
                            size: 40,
                            color: Colors.red[600],
                            semanticLabel: 'Added as favorite',
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                isFavorite = true;
                                icon.addFavoriteMovie(movie);
                              },
                            );
                          },
                          child: const Icon(
                            Icons.favorite_border,
                            size: 40,
                            color: Colors.white,
                            semanticLabel: 'Add as favorite',
                          ),
                        ));
                },
              ),
              const SizedBox(width: 20)
            ],
            floating: false,
            pinned: true,
            expandedHeight: 480,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: Image.network(
                    'https://image.tmdb.org/t/p/w220_and_h330_face$posterPath',
                    fit: BoxFit.cover,
                  ),
                ),
                /*
                Positioned(
                  right: 20,
                  top: 45,
                  child: Consumer<Favorites>(
                    builder: (context, icon, child) {
                      isFavorite = icon.favoriteMovies.contains(movie);
                      return (isFavorite
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorite = false;
                                  icon.removeFavoriteMovie(movie);
                                });
                              },
                              child: Icon(
                                Icons.favorite,
                                size: 60,
                                color: Colors.red[600],
                                semanticLabel: 'Added as favorite',
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorite = true;
                                  icon.addFavoriteMovie(movie);
                                });
                              },
                              child: const Icon(
                                Icons.favorite_border,
                                size: 60,
                                color: Colors.white,
                                semanticLabel: 'Add as favorite',
                              ),
                            ));
                    },
                  ),
                )
                */
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  margin: const EdgeInsets.only(bottom: 3, top: 10),
                  child: Row(
                    children: [
                      Text(
                        "Ano de Lançamento - ",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ano,
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.tertiary),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  margin: const EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Text(
                        "Rating: ",
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        rate.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  margin: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: genresNames.length,
                          itemBuilder: (context, index) => Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Row(
                              children: [
                                Text(
                                  genresNames[index],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  margin: const EdgeInsets.all(3),
                  child: Text("Sinopse: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.tertiary)),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  margin: const EdgeInsets.all(3),
                  child: Expanded(
                      child: Text(overview,
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.tertiary))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
