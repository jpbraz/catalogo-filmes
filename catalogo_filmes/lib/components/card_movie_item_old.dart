import 'package:catalogo_filmes/models/movie_old.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:catalogo_filmes/utils/app_routes.dart';

class CardMovieItem extends StatelessWidget {
  final Movie movie;
  final bool displayTitle;
  final bool displayCircularIndicator;

  const CardMovieItem(
      this.movie, this.displayTitle, this.displayCircularIndicator,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String movieTitle = movie.title as String;
    String posterPath = movie.posterPath as String;
    String releaseDate = movie.releaseDate as String;
    String ano = releaseDate.substring(0, 4);
    num? rate = movie.voteAverage;
    int percentual = (rate! * 10).toInt();

    const boxShadow2 = BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 4,
      color: Colors.black54,
    );

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.DETAILS, arguments: movie);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [boxShadow2],
          shape: BoxShape.rectangle,
          image: DecorationImage(
            opacity: 20,
            image: NetworkImage(
              'https://image.tmdb.org/t/p/w220_and_h330_face$posterPath',
            ),
            fit: BoxFit.fill,
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (displayTitle)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      movieTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [boxShadow2],
                      ),
                    ),
                    Text(
                      ano,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        shadows: [boxShadow2],
                      ),
                    ),
                  ],
                ),
              ),
            if (displayCircularIndicator)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularPercentIndicator(
                    animation: true,
                    rotateLinearGradient: true,
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: rate / 10,
                    center: Text(
                      '$percentual',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    progressColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}