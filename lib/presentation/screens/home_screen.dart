import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/movie_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/movie_list.dart';
import '../../data/models/movie.dart';
import '../../l10n/generated/app_localizations.dart';
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
    _tabController = TabController(length: 4, vsync: this);

    // O carregamento dos dados principais já é feito no construtor do MovieProvider.
    // Aqui, só precisamos carregar dados específicos do usuário, como o histórico.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);

      if (authProvider.currentUser != null) {
        movieProvider.loadRecentHistory(authProvider.currentUser!.id!);
      }

      // Opcional: se quiser ter um "puxar para atualizar"
      // movieProvider.refresh();
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
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
              context.go('/welcome');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.search_placeholder,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          style: TextStyle(color: theme.colorScheme.onSurface),
          onChanged: _onSearchChanged,
          autofocus: true,
        )
            : Text(l10n.app_name),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return CircleAvatar(
                  radius: 16,
                  backgroundImage: authProvider.currentUser?.avatarUrl != null
                      ? CachedNetworkImageProvider(authProvider.currentUser!.avatarUrl!)
                      : null,
                  child: authProvider.currentUser?.avatarUrl == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (_isSearching && _searchController.text.isNotEmpty) {
            return _buildSearchResults(movieProvider, l10n);
          }

          return Column(
            children: [
              // User greeting and recent history
              _buildUserSection(l10n, theme),
              // Movie categories
              Expanded(
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        Tab(text: l10n.popular_movies),
                        Tab(text: l10n.movies_title),
                        Tab(text: l10n.category_action),
                        Tab(text: l10n.category_comedy),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          MovieList(
                            movies: movieProvider.popularMovies,
                            isLoading: movieProvider.isLoading,
                            onMovieTap: _onMovieTap,
                          ),
                          MovieList(
                            movies: movieProvider.topRatedMovies,
                            isLoading: movieProvider.isLoading,
                            onMovieTap: _onMovieTap,
                          ),
                          // --- MODIFICADO ---
                          // Substituímos o FutureBuilder problemático
                          MovieList(
                            movies: movieProvider.actionMovies,
                            isLoading: movieProvider.isLoading,
                            onMovieTap: _onMovieTap,
                          ),
                          MovieList(
                            movies: movieProvider.comedyMovies,
                            isLoading: movieProvider.isLoading,
                            onMovieTap: _onMovieTap,
                          ),
                          // --------------------
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserSection(AppLocalizations l10n, ThemeData theme) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User greeting
                  Text(
                    l10n.home_greeting(authProvider.currentUser?.name ?? l10n.default_user_name),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Recent history
                  if (movieProvider.recentHistory.isNotEmpty) ...[
                    Text(
                      l10n.recently_viewed,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movieProvider.recentHistory.length,
                        itemBuilder: (context, index) {
                          final historyEntry = movieProvider.recentHistory[index];
                          return Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => _onMovieTap(Movie(
                                id: historyEntry.movieId,
                                title: historyEntry.movieTitle,
                                originalTitle: historyEntry.movieTitle,
                                overview: '',
                                posterPath: historyEntry.moviePosterPath,
                                backdropPath: null,
                                releaseDate: '',
                                voteAverage: 0.0,
                                voteCount: 0,
                                adult: false,
                                genreIds: [],
                                video: null,
                                popularity: 0.0,
                                originalLanguage: '',
                              )),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: historyEntry.fullPosterUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: theme.colorScheme.surface,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: theme.colorScheme.surface,
                                          child: const Icon(Icons.movie),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    historyEntry.movieTitle,
                                    style: theme.textTheme.bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResults(MovieProvider movieProvider, AppLocalizations l10n) {
    if (movieProvider.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (movieProvider.searchResults.isEmpty && movieProvider.searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.search_no_results(movieProvider.searchQuery),
              style: Theme.of(context).textTheme.titleLarge,
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

  void _onMovieTap(Movie movie) {
    // Add to history
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      movieProvider.addToHistory(authProvider.currentUser!.id!, movie);
    }

    // Navigate to movie detail
    context.go('/movie/${movie.id}');
  }
}