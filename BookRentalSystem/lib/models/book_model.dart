class Book {
  final String image;
  final String title;
  final String author;
  final String genre;
  final String description;

  Book({
    required this.image,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      image: json['img_url'] ?? '',
      title: json['name'] ?? '',
      author: json['author'] ?? '',
      genre: json['category'] ?? '',
      description: json['description'] ?? '',
    );
  }
}