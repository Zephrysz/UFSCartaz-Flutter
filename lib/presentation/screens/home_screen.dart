import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/movie_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/movie_list.dart';
import '../../data/models/movie.dart';
// ADICIONADO: Import para o modelo MovieHistoryEntry
import '../../data/models/movie_history_entry.dart';
import '../../core/constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);

      if (authProvider.currentUser != null) {
        movieProvider.loadRecentHistory(authProvider.currentUser!.id!);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        Provider.of<MovieProvider>(context, listen: false).clearSearch();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      Provider.of<MovieProvider>(context, listen: false).searchMovies(query);
    } else {
      Provider.of<MovieProvider>(context, listen: false).clearSearch();
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
              context.go('/welcome');
            },
            child: const Text('Logout', style: TextStyle(color: Color(0xFFE53E3E))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        //... seu AppBar (sem alterações)
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Para você, Lucas',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearchChanged,
          autofocus: true,
        )
            : Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Text(
              'Para você, ${authProvider.currentUser?.name ?? 'Lucas'}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return GestureDetector(
                onTap: _logout,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFE53E3E),
                    child: authProvider.currentUser?.avatarUrl != null
                        ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: authProvider.currentUser!.avatarUrl!,
                        fit: BoxFit.cover,
                        width: 36,
                        height: 36,
                        placeholder: (context, url) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                        : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (_isSearching && _searchController.text.isNotEmpty) {
            return _buildSearchResults(movieProvider);
          }

          return Column(
            children: [
              // Featured movie section
              _buildFeaturedSection(movieProvider),
              // Movie categories
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Historico section
                      if (movieProvider.recentHistory.isNotEmpty)
                        _buildHistorySection(
                          'Vistos Recentemente',
                          movieProvider.recentHistory,
                        ),
                      // All Movies section
                      _buildMovieSection(
                        'All Movies',
                        movieProvider.popularMovies,
                        movieProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                      // Documentaries section
                      _buildMovieSection(
                        'Documentários',
                        movieProvider.actionMovies,
                        movieProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                      // Comedy section
                      _buildMovieSection(
                        'Comédia',
                        movieProvider.comedyMovies,
                        movieProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                      // Drama section
                      _buildMovieSection(
                        'Drama',
                        movieProvider.topRatedMovies,
                        movieProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection(MovieProvider movieProvider) {
    //... sem alterações nesta função
    if (movieProvider.isLoading) {
      return Container(
        height: 200,
        color: const Color(0xFF1A1A1A),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE53E3E),
          ),
        ),
      );
    }

    if (movieProvider.popularMovies.isEmpty) {
      return Container(
        height: 200,
        color: const Color(0xFF1A1A1A),
        child: const Center(
          child: Text(
            'No movies available',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final featuredMovie = movieProvider.popularMovies.first;
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            '${AppConstants.imageBaseUrl}${featuredMovie.backdropPath ?? featuredMovie.posterPath}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                featuredMovie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                featuredMovie.overview,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _onMovieTap(featuredMovie),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53E3E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Assistir'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => _onMovieTap(featuredMovie),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Mais info'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CORRIGIDO: O tipo de 'history' agora é reconhecido
  Widget _buildHistorySection(String title, List<MovieHistoryEntry> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180, // Altura da lista horizontal
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              // CORRIGIDO: Objeto Movie criado com todos os parâmetros obrigatórios
              final movieFromHistory = Movie(
                id: entry.movieId,
                title: entry.movieTitle,
                originalTitle: entry.movieTitle, // Usando movieTitle como fallback
                overview: '', // Fornecendo valor padrão
                posterPath: entry.moviePosterPath,
                backdropPath: entry.moviePosterPath, // Usando poster como fallback
                releaseDate: '', // Fornecendo valor padrão
                voteAverage: 0.0, // Fornecendo valor padrão
                genreIds: [], // Fornecendo valor padrão
                adult: false, // Fornecendo valor padrão
                originalLanguage: '', // Fornecendo valor padrão
                popularity: 0.0, // Fornecendo valor padrão
                video: false, // Fornecendo valor padrão
                voteCount: 0, // Fornecendo valor padrão
              );

              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 8.0,
                  right: index == history.length - 1 ? 16.0 : 0,
                ),
                child: GestureDetector(
                  onTap: () => _onMovieTap(movieFromHistory),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: entry.fullPosterUrl,
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey[800],
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey[800],
                            child: const Icon(Icons.movie, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSearchResults(MovieProvider movieProvider) {
    //... sem alterações nesta função
    if (movieProvider.isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE53E3E),
        ),
      );
    }

    if (movieProvider.searchResults.isEmpty && movieProvider.searchQuery.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white70,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return MovieList(
      movies: movieProvider.searchResults,
      isLoading: movieProvider.isSearching,
      onMovieTap: _onMovieTap,
    );
  }

  Widget _buildMovieSection(String title, List<Movie> movies, bool isLoading) {
    //... sem alterações nesta função
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        MovieList(
          movies: movies,
          isLoading: isLoading,
          onMovieTap: _onMovieTap,
        ),
      ],
    );
  }

  void _onMovieTap(Movie movie) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      movieProvider.addToHistory(authProvider.currentUser!.id!, movie);
    }

    context.go('/movie/${movie.id}');
  }
}