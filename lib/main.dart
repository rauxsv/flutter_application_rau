import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_rau/bloc/rau_bloc.dart';
import 'package:flutter_application_rau/bloc/rau_event.dart';
import 'package:flutter_application_rau/bloc/rau_state.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_rau/models/post_model.dart';
import 'package:flutter_application_rau/service/api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bottom Nav Bar',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  final RAUBloc _bloc = RAUBloc();
  final Dio _dio = Dio();  
  late final ApiService _apiService = ApiService(_dio);

  @override
  void initState() {
    super.initState();
    _pages = [
      CommentPage(_bloc, _apiService),
      Page2(),
      Page3(),
      Page4(),
    ];
    _bloc.addEvent.add(FetchCommentsEvent());
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Дом',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Аккаунт',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Работа',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Фото',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}

class CommentPage extends StatelessWidget {
  final RAUBloc bloc;
  final ApiService apiService;

  CommentPage(this.bloc, this.apiService);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: FutureBuilder<List<PostModel>>(
        future: apiService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }


            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/myani.json'),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/yourani.json'),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/theirani.json'),
    );
  }
}
