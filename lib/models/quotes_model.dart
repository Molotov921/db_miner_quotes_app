import 'package:get/get.dart';

class Quote {
  final int id;
  final String quote;
  final String author;
  late RxBool isFavorite;

  Quote({
    required this.id,
    required this.quote,
    required this.author,
    required this.isFavorite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quote': quote,
      'author': author,
    };
  }
}
