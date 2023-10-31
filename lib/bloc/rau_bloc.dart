import 'dart:async';
import 'package:flutter_application_rau/models/post_model.dart';
import 'rau_event.dart';
import 'rau_state.dart';
import 'package:dio/dio.dart'; 
import 'package:flutter_application_rau/service/api_service.dart';    

class RAUBloc {
  final _stateController = StreamController<RAUState>.broadcast();
  StreamSink<RAUState> get _inState => _stateController.sink;
  Stream<RAUState> get state => _stateController.stream;

  final _eventController = StreamController<RAUEvent>();
  Sink<RAUEvent> get addEvent => _eventController.sink;

  final ApiService apiService = ApiService(Dio());  

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

  Future<List<PostModel>?> _fetchComments() async {   
    try {
      final response = await apiService.getPosts();   
      return response;                               
    } catch (error) {
      return null;
    }
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
