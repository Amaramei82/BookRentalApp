class Book {
  final String id;
  final String name;
  final String author;
  final String category;
  final String imgUrl;
  final double rent;
  final String isbn;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.category,
    required this.imgUrl,
    required this.rent,
    required this.isbn,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      name: json['name'],
      author: json['author'],
      category: json['category'] ?? 'Uncategorized',
      imgUrl: json['img_url'],
      rent: double.parse(json['rent'].toString()),
      isbn: json['ISBN'] ?? '',
    );
  }
}