import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Movie> movies = [];

  bool isLoading = true;

  String errorMessage = "";

  String keyword = "marvel";

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {

      final data = await MovieService.fetchMovies(keyword);

      setState(() {
        movies = data;
        isLoading = false;
        errorMessage = "";
      });

    } catch (e) {

      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });

      print("🔴 Lỗi: $errorMessage");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "TH3 - Đỗ Quang Nam Anh - 2351160501",
          style: TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadMovies,
          )
        ],
      ),

      body: Column(
        children: [

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Tìm phim (Avengers, Spider Man...)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),

              onSubmitted: (value) {

                FocusScope.of(context).unfocus();

                if (value.trim().isEmpty) return;

                keyword = value.trim();

                loadMovies();
              },
            ),
          ),

          Expanded(
            child: buildBody(),
          )
        ],
      ),
    );
  }

  Widget buildBody() {

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage.isNotEmpty) {

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.wifi_off,
              size: 50,
              color: Colors.grey,
            ),

            const SizedBox(height: 10),

            Text(errorMessage),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: loadMovies,
              child: const Text("Thử lại"),
            ),
          ],
        ),
      );
    }

    if (movies.isEmpty) {

      return const Center(
        child: Text("Không tìm thấy phim"),
      );
    }

    return RefreshIndicator(

      onRefresh: loadMovies,

      child: GridView.builder(

        padding: const EdgeInsets.all(10),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),

        itemCount: movies.length,

        itemBuilder: (context, index) {

          return MovieCard(
            movie: movies[index],
          );
        },
      ),
    );
  }
}