import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/movie_provider.dart';
// Removido, pois não é usado
// import '../providers/theme_provider.dart';
import '../widgets/movie_list.dart';
import '../../data/models/movie.dart';
import '../../data/models/movie_history_entry.dart';
import '../../core/constants/app_constants.dart';

// Importe o arquivo de localizações gerado
import '../../l10n/generated/app_localizations.dart';

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
    // A inicialização do TabController parece não ser usada, mas mantida caso seja para uso futuro
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
    // Obtenha a instância de AppLocalizations para usar no diálogo
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text(l10n.logout_title, style: const TextStyle(color: Colors.white)), // Substituído
        content: Text(l10n.logout_confirmation_message, style: const TextStyle(color: Colors.white)), // Substituído
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel_button, style: const TextStyle(color: Colors.white70)), // Substituído
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
              context.go('/welcome');
            },
            child: Text(l10n.logout_title, style: const TextStyle(color: Color(0xFFE53E3E))), // Substituído
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenha a instância de AppLocalizations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.search_placeholder, // Substituído
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearchChanged,
          autofocus: true,
        )
            : Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Usa a string de saudação com o nome do usuário ou um padrão
            final userName = authProvider.currentUser?.name ?? l10n.default_user_name;
            return Text(
              l10n.home_greeting(userName), // Substituído
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
                    // O conteúdo do avatar não é texto, então permanece como está
                    child: authProvider.currentUser?.avatarUrl != null
                        ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: authProvider.currentUser!.avatarUrl!,
                        fit: BoxFit.cover,
                        width: 36,
                        height: 36,
                        placeholder: (context, url) => const Icon(Icons.person, color: Colors.white, size: 20),
                        errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                    )
                        : const Icon(Icons.person, color: Colors.white, size: 20),
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
            return _buildSearchResults(movieProvider, l10n);
          }

          return Column(
            children: [
              _buildFeaturedSection(movieProvider, l10n),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      if (movieProvider.recentHistory.isNotEmpty)
                        _buildHistorySection(
                          l10n.recently_viewed, // Substituído
                          movieProvider.recentHistory,
                        ),
                      _buildMovieSection(
                        l10n.all_movies, // Substituído
                        movieProvider.popularMovies,
                        movieProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                      _buildMovieSection(
                        l10n.category_documentaries, // Substituído
                        movieProvider.actionMovies,
                        movieProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                      _buildMovieSection(
                        l10n.category_comedy, // Substituído
                        movieProvider.comedyMovies,
                        movieProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                      _buildMovieSection(
                        l10n.category_drama, // Substituído
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

  Widget _buildFeaturedSection(MovieProvider movieProvider, AppLocalizations l10n) {
    if (movieProvider.isLoading) {
      return Container(
        height: 200,
        color: const Color(0xFF1A1A1A),
        child: const Center(child: CircularProgressIndicator(color: Color(0xFFE53E3E))),
      );
    }

    if (movieProvider.popularMovies.isEmpty) {
      return Container(
        height: 200,
        color: const Color(0xFF1A1A1A),
        child: Center(
          child: Text(
            l10n.no_movies_available, // Substituído
            style: const TextStyle(color: Colors.white70),
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
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(featuredMovie.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                featuredMovie.overview,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(l10n.watch_button), // Substituído
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => _onMovieTap(featuredMovie),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(l10n.more_info_button), // Substituído
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection(String title, List<MovieHistoryEntry> history) {
    // O conteúdo desta função não contém strings visíveis ao usuário, então permanece como está.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              final movieFromHistory = Movie(
                id: entry.movieId,
                title: entry.movieTitle,
                originalTitle: entry.movieTitle,
                overview: '',
                posterPath: entry.moviePosterPath,
                backdropPath: entry.moviePosterPath,
                releaseDate: '',
                voteAverage: 0.0,
                genreIds: [],
                adult: false,
                originalLanguage: '',
                popularity: 0.0,
                video: false,
                voteCount: 0,
              );

              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 16.0 : 8.0, right: index == history.length - 1 ? 16.0 : 0),
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
                          placeholder: (context, url) => Container(width: 120, height: 180, color: Colors.grey[800]),
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

  Widget _buildSearchResults(MovieProvider movieProvider, AppLocalizations l10n) {
    if (movieProvider.isSearching) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFE53E3E)));
    }

    if (movieProvider.searchResults.isEmpty && movieProvider.searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              l10n.no_movies_found, // Substituído
              style: const TextStyle(color: Colors.white70, fontSize: 18),
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
    // Apenas o título desta seção é uma string, que é passada como argumento
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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