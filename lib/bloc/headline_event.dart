part of 'headline_bloc.dart';

abstract class HeadlineEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostFetched extends HeadlineEvent {}