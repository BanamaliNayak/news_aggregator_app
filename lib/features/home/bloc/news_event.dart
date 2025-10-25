import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object?> get props => [];
}

class FetchNews extends NewsEvent {
  final String category;
  const FetchNews({required this.category});
  @override
  List<Object?> get props => [category];
}

class RefreshNews extends NewsEvent {
  final String category;
  const RefreshNews({required this.category});
  @override
  List<Object?> get props => [category];
}