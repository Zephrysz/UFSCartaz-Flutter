import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/movie_provider.dart';
import '../../data/models/movie.dart';
// Certifique-se de que o caminho de importação está correto para seu projeto.
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
      backgroundColor: Colors.black,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoadingDetails) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE53E3E)));
          }

          final movie = movieProvider.selectedMovie;
          if (movie == null) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: const Color(0xFF1A1A1A),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFFE53E3E),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.movie_not_found,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: const Color(0xFF1A1A1A),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movie.fullBackdropUrl.isNotEmpty
                            ? movie.fullBackdropUrl
                            : movie.fullPosterUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.colorScheme.surface,
                          child: const Center(child: CircularProgressIndicator(color: Color(0xFFE53E3E))),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.surface,
                          child: const Icon(Icons.movie, size: 64),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: movie.fullPosterUrl,
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 120, height: 180, color: theme.colorScheme.surface,
                                child: const Center(child: CircularProgressIndicator(color: Color(0xFFE53E3E))),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 120, height: 180, color: theme.colorScheme.surface,
                                child: const Icon(Icons.movie, size: 48),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                if (movie.releaseYear.isNotEmpty)
                                  Text(movie.releaseYear, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(l10n.rating(movie.voteAverage), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text('(${movie.voteCount})', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: movie.genreIds.take(3).map((genreId) {
                                    final genreName = _getGenreName(genreId, l10n);
                                    return Chip(
                                      label: Text(genreName, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white)),
                                      backgroundColor: const Color(0xFFE53E3E).withOpacity(0.8),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(l10n.overview_title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isNotEmpty ? movie.overview : l10n.no_overview_available,
                        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 24),
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
      color: const Color(0xFF2D2D2D),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.movie_information_title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(l10n.original_title_label, movie.originalTitle),
            _buildInfoRow(l10n.release_date_label, movie.releaseDate),
            _buildInfoRow(l10n.language_label, movie.originalLanguage.toUpperCase()),
            _buildInfoRow(l10n.popularity_label, movie.popularity.toStringAsFixed(1)),
            if (movie.adult)
              _buildInfoRow(l10n.content_rating_label, l10n.adult_rating),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGenreName(int genreId, AppLocalizations l10n) {
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
      default: return l10n.unknown_genre; // Substituído
    }
  }
}