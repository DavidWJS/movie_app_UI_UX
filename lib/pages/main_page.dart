import 'package:flutter/material.dart';
import 'package:movie_app/constants/movie_db_provider_const.dart';
import 'package:movie_app/data/provider/movies_notifier.dart';
import 'package:movie_app/pages/detail_page.dart';
import 'package:movie_app/repository/movie_db_provider.dart';
import 'package:movie_app/widgets/poster.dart';
import 'package:provider/provider.dart';

const double SCALE_FACTOR = 0.9;
const double VIEW_PORT_FACTOR = 0.7;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static int _selectedIndex = 0;
  static PageController _pageController;
  static Page _page = Page();
  static Size size;

  static double nowPlayingTop = 16;
  static double posterTop = 72;
  static double ratingTop = size.width + posterTop + 16;
  static double titleTop = ratingTop + 18 + 8;
  static double genreTop = titleTop + 26 + 8;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<BottomNavigationBarItem> _bnbItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      title: Text('Business'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      title: Text('School'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    movieDBProvider.discoverMovies();
    _pageController = PageController(viewportFraction: VIEW_PORT_FACTOR)
      ..addListener(_onPageViewScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageViewScroll() {
    _page.value = _pageController.page;
    //_pageScale.value = 1 + (SCALE_FACTOR - 1) * (_pageController.page - _pageController.page.floor()).abs();
    /*setState(() {
      _page = _pageController.page;
    });
    print('page: ${_pageController.page}');
    print('position: ${_pageController.position}');

    print('${_pageController.page} - $_previousPage = ${(_pageController.page - _previousPage).abs()}');
    setState(() {
      _previousPageScale =
          (1 - SCALE_FACTOR) * (_pageController.page - _previousPage).abs() +
              SCALE_FACTOR;
    });

    if (_pageController.page == _pageController.page.toInt()) {
      _previousPage = _pageController.page;
      //_onBottomItemTapped(_pageController.page.toInt());
    }
    //print(_previousPageScale);*/
  }

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //_pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    //Size size = MediaQuery.of(context).size;
    //double transScale = 2 - SCALE_FACTOR;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _bnbItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onBottomItemTapped,
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: Stack(
            children: <Widget>[
              TextField(),
              Positioned(
                top: nowPlayingTop,
                left: 16,
                height: 40,
                child: FittedBox(
                  child: Text(
                    'Now Playing',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Positioned(
                top: ratingTop,
                left: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.blueGrey[800],
                          )),
                      child: Text(
                        'IMDB',
                        style: TextStyle(
                            fontSize: 14, color: Colors.blueGrey[800]),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '6.4',
                      style:
                          TextStyle(fontSize: 14, color: Colors.blueGrey[800]),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: titleTop,
                  left: 16,
                  child: Text('John Wick: Chapter 3',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold))),
              Positioned(
                  top: genreTop,
                  left: 16,
                  child: Text(
                    'Action, Crime, Thriller',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.grey[600]),
                  )),
              Positioned(
                  top: posterTop,
                  left: 0,
                  right: 0,
                  height: size.width,
                  child:
                      PostPager(page: _page, pageController: _pageController)),
            ],
          ),
        ),
      ),
    );
  }
}

class PostPager extends StatelessWidget {
  const PostPager({
    Key key,
    @required Page page,
    @required PageController pageController,
  })  : _page = page,
        _pageController = pageController,
        super(key: key);

  final Page _page;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MoviesNotifier>.value(value: moviesNotifier),
        ChangeNotifierProvider<Page>.value(value: _page),
      ],
      child: AspectRatio(
        aspectRatio: 1,
        child: Consumer<MoviesNotifier>(
          builder: (context, movieNotifier, child) {
            return PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                return Consumer<Page>(
                  builder: (context, page, child) {
                    double scale = 1 +
                        (SCALE_FACTOR - 1) *
                            (page.value - index.toDouble()).abs();
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => DetailPage(movieNotifier.movies[index])));
                      },
                      child: Poster(
                        scale: scale,
                        img: movieNotifier.movies[index].posterPath,
                      ),
                    );
                  },
                );
              },
              itemCount: movieNotifier.movies.length,
            );
          },
        ),
      ),
    );
  }
}

class Page extends ChangeNotifier {
  double _page = 0;

  double get value => _page;

  set value(double page) {
    _page = page;
    notifyListeners();
  }
}
