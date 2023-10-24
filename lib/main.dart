import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_rau/bloc/rau_bloc.dart';
import 'package:flutter_application_rau/bloc/rau_event.dart';
import 'package:flutter_application_rau/bloc/rau_state.dart';
import 'package:lottie/lottie.dart';

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

  @override
  void initState() {
    super.initState();
    _pages = [
      CommentPage(_bloc),
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
  CommentPage(this.bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comments')),
      body: StreamBuilder<RAUState>(
        initialData: RAUInitial(),
        stream: bloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is CommentsLoaded) {
            List<Comment> comments = (snapshot.data as CommentsLoaded).comments;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                Comment comment = comments[index];
                return ListTile(
                  title: Text(comment.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('postId: ${comment.postId}'),
                      Text('id: ${comment.id}'),
                      Text('email: ${comment.email}'),
                      Text('body: ${comment.body}'),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasData && snapshot.data is CommentsError) {
            return Center(
                child: Text((snapshot.data as CommentsError).message));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Comment(
      {required this.postId,
      required this.id,
      required this.name,
      required this.email,
      required this.body});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
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
      child: Icon(Icons.photo, size: 100, color: Colors.blue),
    );
  }
}
