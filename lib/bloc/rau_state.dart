import 'package:flutter_application_rau/main.dart';

abstract class RAUState {}

class RAUInitial extends RAUState {}

class CommentsLoaded extends RAUState {
  final List<Comment> comments;

  CommentsLoaded(this.comments);
}

class CommentsError extends RAUState {
  final String message;

  CommentsError(this.message);
}
