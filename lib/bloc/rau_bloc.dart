import 'dart:async';
import 'package:flutter_application_rau/main.dart';
import 'rau_event.dart';
import 'rau_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RAUBloc {
  final _stateController = StreamController<RAUState>.broadcast();
  StreamSink<RAUState> get _inState => _stateController.sink;
  Stream<RAUState> get state => _stateController.stream;

  final _eventController = StreamController<RAUEvent>();
  Sink<RAUEvent> get addEvent => _eventController.sink;

  RAUBloc() {
    _eventController.stream.listen((event) async {
      if (event is FetchCommentsEvent) {
        final comments = await _fetchComments();
        if (comments != null) {
          _inState.add(CommentsLoaded(comments));
        } else {
          _inState.add(CommentsError('Ошибка при загрузке комментариев'));
        }
      }
    });
  }

  Future<List<Comment>?> _fetchComments() async {
    try {
      final response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/1/comments'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Comment.fromJson(data)).toList();
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
