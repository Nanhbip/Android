import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'dart:developer' as developer;

class MovieService {

  static const String apiKey = "827a1a0f";

  static Future<List<Movie>> fetchMovies(String keyword) async {

    final url =
        "https://www.omdbapi.com/?s=${Uri.encodeComponent(keyword)}&apikey=$apiKey";

    developer.log("📡 Requesting: $url");

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      developer.log("📥 Response status: ${response.statusCode}");
      developer.log("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["Response"] == "False") {
          developer.log("⚠️ API returned False. Error: ${data["Error"]}");
          throw Exception(data["Error"] ?? "Không tìm thấy kết quả");
        }

        final searchList = data["Search"];
        if (searchList == null) {
          developer.log("⚠️ No Search field in response");
          throw Exception("Không tìm thấy dữ liệu phim");
        }

        developer.log("✅ Found ${searchList.length} movies");
        return (searchList as List)
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();

      } else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    } on http.ClientException catch (e) {
      developer.log("❌ Network error: $e");
      throw Exception("Kiểm tra kết nối mạng: ${e.message}");
    } catch (e) {
      developer.log("❌ Error: $e");
      rethrow;
    }
  }
}