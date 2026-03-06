class Movie {
  final String title;
  final String year;
  final String poster;

  Movie({
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? 'No Title',
      year: json['Year'] ?? 'Unknown',
      poster: json['Poster'] != "N/A"
          ? json['Poster']
          : "https://via.placeholder.com/300x450",
    );
  }
}