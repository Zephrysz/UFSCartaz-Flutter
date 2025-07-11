import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/movie_provider.dart';
import '../../data/models/movie.dart';
import '../../l10n/generated/app_localizations.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  
  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false)
          .getMovieDetails(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoadingDetails) {
            return const Center(child: CircularProgressIndicator());
          }

          final movie = movieProvider.selectedMovie;
          if (movie == null) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.movie_not_found,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App bar with backdrop image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Backdrop image
                      CachedNetworkImage(
                        imageUrl: movie.fullBackdropUrl.isNotEmpty
                            ? movie.fullBackdropUrl
                            : movie.fullPosterUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.colorScheme.surface,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.surface,
                          child: const Icon(
                            Icons.movie,
                            size: 64,
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Movie details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie poster and basic info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: movie.fullPosterUrl,
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 120,
                                height: 180,
                                color: theme.colorScheme.surface,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 120,
                                height: 180,
                                color: theme.colorScheme.surface,
                                child: const Icon(
                                  Icons.movie,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Movie info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  movie.title,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Release year
                                if (movie.releaseYear.isNotEmpty)
                                  Text(
                                    movie.releaseYear,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                // Rating
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      l10n.rating(movie.voteAverage),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${movie.voteCount})',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Genre chips
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: movie.genreIds.take(3).map((genreId) {
                                    final genreName = _getGenreName(genreId, l10n);
                                    return Chip(
                                      label: Text(
                                        genreName,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Overview
                      Text(
                        l10n.overview_title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isNotEmpty ? movie.overview : l10n.no_overview_available,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Additional info
                      _buildInfoSection(l10n, theme, movie),
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

  Widget _buildInfoSection(AppLocalizations l10n, ThemeData theme, Movie movie) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movie Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Original Title', movie.originalTitle, theme),
            _buildInfoRow('Release Date', movie.releaseDate, theme),
            _buildInfoRow('Language', movie.originalLanguage.toUpperCase(), theme),
            _buildInfoRow('Popularity', movie.popularity.toStringAsFixed(1), theme),
            if (movie.adult)
              _buildInfoRow('Content Rating', 'Adult', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _getGenreName(int genreId, AppLocalizations l10n) {
    // Map genre IDs to localized names
    switch (genreId) {
      case 28: return l10n.category_action;
      case 12: return l10n.category_adventure;
      case 16: return l10n.category_animation;
      case 35: return l10n.category_comedy;
      case 80: return l10n.category_crime;
      case 99: return l10n.category_documentaries;
      case 18: return l10n.category_drama;
      case 10751: return l10n.category_family;
      case 14: return l10n.category_fantasy;
      case 36: return l10n.category_history;
      case 27: return l10n.category_horror;
      case 10402: return l10n.category_music;
      case 9648: return l10n.category_mystery;
      case 10749: return l10n.category_romance;
      case 878: return l10n.category_scifi;
      case 10770: return l10n.category_tv_movie;
      case 53: return l10n.category_thriller;
      case 10752: return l10n.category_war;
      case 37: return l10n.category_western;
      default: return 'Unknown';
    }
  }
} 