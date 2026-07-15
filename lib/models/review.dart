class Review {
  const Review({
    required this.author,
    required this.rating,
    required this.comment,
  });

  final String author;
  final int rating;
  final String comment;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
    );
  }
}
