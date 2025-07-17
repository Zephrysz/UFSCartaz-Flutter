// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'UFSCARTAZ';

  @override
  String get logo_part1 => 'UFSCAR';

  @override
  String get logo_part2 => 'TAZ';

  @override
  String get welcome_subtitle => 'Endless entertainment, all in one place';

  @override
  String get button_register => 'REGISTER';

  @override
  String get button_login => 'LOGIN';

  @override
  String get auth_welcome_back => 'Welcome back!';

  @override
  String get auth_welcome => 'Welcome!';

  @override
  String get label_name => 'Name';

  @override
  String get label_email => 'Email';

  @override
  String get label_password => 'Password';

  @override
  String get title_choose_avatar => 'Choose avatar';

  @override
  String get button_skip => 'Skip';

  @override
  String get label_avatar => 'Avatar';

  @override
  String get button_continue => 'Continue';

  @override
  String get avatar_selection_placeholder => 'Avatar options would appear here';

  @override
  String get recently_viewed => 'Recently Viewed';

  @override
  String home_greeting(String username) {
    return 'For you, $username';
  }

  @override
  String get default_user_name => 'User';

  @override
  String get content_description_user_avatar => 'User avatar';

  @override
  String get category_documentaries => 'Documentaries';

  @override
  String get category_comedy => 'Comedy';

  @override
  String get category_drama => 'Drama';

  @override
  String get category_action => 'Action';

  @override
  String get category_adventure => 'Adventure';

  @override
  String get category_horror => 'Horror';

  @override
  String get category_scifi => 'Science Fiction';

  @override
  String get category_romance => 'Romance';

  @override
  String get category_animation => 'Animation';

  @override
  String get category_crime => 'Crime';

  @override
  String get category_family => 'Family';

  @override
  String get category_fantasy => 'Fantasy';

  @override
  String get category_history => 'History';

  @override
  String get category_music => 'Music';

  @override
  String get category_mystery => 'Mystery';

  @override
  String get category_tv_movie => 'TV Movie';

  @override
  String get category_thriller => 'Thriller';

  @override
  String get category_war => 'War';

  @override
  String get category_western => 'Western';

  @override
  String get explore_movies => 'Explore Movies';

  @override
  String get movies_title => 'Movies';

  @override
  String get movie_list_content => 'Movie List';

  @override
  String get all_movies => 'All Movies';

  @override
  String get popular_movies => 'Popular Movies';

  @override
  String get search_hint => 'Search movies...';

  @override
  String get search_placeholder => 'What do you want to watch?';

  @override
  String get search_button => 'Search';

  @override
  String get clear_button => 'Clear';

  @override
  String get no_movies_found => 'No movies found';

  @override
  String get try_again => 'Try again';

  @override
  String get unknown_error => 'Unknown error';

  @override
  String get no_movies_in_category => 'No movies found in this category';

  @override
  String get movies => 'Movies';

  @override
  String search_results_for(String query) {
    return 'Results for: \"$query\"';
  }

  @override
  String search_no_results(String query) {
    return 'No movies found for \"$query\"';
  }

  @override
  String get search_type_to_search => 'Type to search movies';

  @override
  String get loading => 'Loading...';

  @override
  String get back => 'Back';

  @override
  String get movie_not_found => 'Movie not found.';

  @override
  String rating(double rating) {
    final intl.NumberFormat ratingNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String ratingString = ratingNumberFormat.format(rating);

    return 'Rating: $ratingString';
  }

  @override
  String get overview_title => 'Overview';

  @override
  String get no_overview_available => 'No overview available.';

  @override
  String get logout_title => 'Logout';

  @override
  String get logout_confirmation_message => 'Are you sure you want to logout?';

  @override
  String get cancel_button => 'Cancel';

  @override
  String get watch_button => 'Watch';

  @override
  String get more_info_button => 'More Info';

  @override
  String get no_movies_available => 'No movies available';

  @override
  String get movie_information_title => 'Movie Information';

  @override
  String get original_title_label => 'Original Title';

  @override
  String get release_date_label => 'Release Date';

  @override
  String get language_label => 'Language';

  @override
  String get popularity_label => 'Popularity';

  @override
  String get content_rating_label => 'Content Rating';

  @override
  String get adult_rating => 'Adult';

  @override
  String get unknown_genre => 'Unknown';

  @override
  String get failed_to_load_avatars => 'Failed to load avatars';

  @override
  String get failed_to_update_avatar => 'Failed to update avatar';

  @override
  String get no_avatars_available => 'No avatars available';

  @override
  String get login_failed => 'Login failed. Please check your credentials.';

  @override
  String get validator_enter_email => 'Please enter your email';

  @override
  String get validator_valid_email => 'Please enter a valid email';

  @override
  String get validator_enter_password => 'Please enter your password';

  @override
  String get validator_password_length =>
      'Password must be at least 6 characters';

  @override
  String get registration_failed => 'Registration failed. Please try again.';

  @override
  String get validator_enter_name => 'Please enter your name';

  @override
  String get validator_name_length => 'Name must be at least 2 characters';
}
