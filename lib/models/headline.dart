import 'package:equatable/equatable.dart';

class Headlines extends Equatable {
  const Headlines({required this.title, required this.image, required this.author, required this.publishedAt, required this.description});

  final String title;
  final String image;
  final String author;
  final String publishedAt;
  final String description;

  @override
  List<Object> get props => [title, image, author, publishedAt, description];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'image': image,
      'author': author,
      'publishedAt': publishedAt,
      'description': description,
    };
    return map;
  }
  
}