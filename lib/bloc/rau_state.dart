import 'package:flutter_application_rau/models/post_model.dart';

abstract class RAUState {}

class RAUInitial extends RAUState {}

class CommentsLoaded extends RAUState {
  final List<PostModel> comments; // <-- Замените Comment на PostModel

  CommentsLoaded(this.comments);
}

class CommentsError extends RAUState {
  final String message;

  CommentsError(this.message);
}
