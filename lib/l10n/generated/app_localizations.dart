import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'UFSCARTAZ'**
  String get app_name;

  /// No description provided for @logo_part1.
  ///
  /// In en, this message translates to:
  /// **'UFSCAR'**
  String get logo_part1;

  /// No description provided for @logo_part2.
  ///
  /// In en, this message translates to:
  /// **'TAZ'**
  String get logo_part2;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Endless entertainment, all in one place'**
  String get welcome_subtitle;

  /// No description provided for @button_register.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get button_register;

  /// No description provided for @button_login.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get button_login;

  /// No description provided for @auth_welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get auth_welcome_back;

  /// No description provided for @auth_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get auth_welcome;

  /// No description provided for @label_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get label_name;

  /// No description provided for @label_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get label_email;

  /// No description provided for @label_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get label_password;

  /// No description provided for @title_choose_avatar.
  ///
  /// In en, this message translates to:
  /// **'Choose avatar'**
  String get title_choose_avatar;

  /// No description provided for @button_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get button_skip;

  /// No description provided for @label_avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get label_avatar;

  /// No description provided for @button_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get button_continue;

  /// No description provided for @avatar_selection_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Avatar options would appear here'**
  String get avatar_selection_placeholder;

  /// No description provided for @recently_viewed.
  ///
  /// In en, this message translates to:
  /// **'Recently Viewed'**
  String get recently_viewed;

  /// Greeting message with username
  ///
  /// In en, this message translates to:
  /// **'For you, {username}'**
  String home_greeting(String username);

  /// No description provided for @default_user_name.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get default_user_name;

  /// No description provided for @content_description_user_avatar.
  ///
  /// In en, this message translates to:
  /// **'User avatar'**
  String get content_description_user_avatar;

  /// No description provided for @category_documentaries.
  ///
  /// In en, this message translates to:
  /// **'Documentaries'**
  String get category_documentaries;

  /// No description provided for @category_comedy.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get category_comedy;

  /// No description provided for @category_drama.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get category_drama;

  /// No description provided for @category_action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get category_action;

  /// No description provided for @category_adventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get category_adventure;

  /// No description provided for @category_horror.
  ///
  /// In en, this message translates to:
  /// **'Horror'**
  String get category_horror;

  /// No description provided for @category_scifi.
  ///
  /// In en, this message translates to:
  /// **'Science Fiction'**
  String get category_scifi;

  /// No description provided for @category_romance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get category_romance;

  /// No description provided for @category_animation.
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get category_animation;

  /// No description provided for @category_crime.
  ///
  /// In en, this message translates to:
  /// **'Crime'**
  String get category_crime;

  /// No description provided for @category_family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get category_family;

  /// No description provided for @category_fantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get category_fantasy;

  /// No description provided for @category_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get category_history;

  /// No description provided for @category_music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get category_music;

  /// No description provided for @category_mystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get category_mystery;

  /// No description provided for @category_tv_movie.
  ///
  /// In en, this message translates to:
  /// **'TV Movie'**
  String get category_tv_movie;

  /// No description provided for @category_thriller.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get category_thriller;

  /// No description provided for @category_war.
  ///
  /// In en, this message translates to:
  /// **'War'**
  String get category_war;

  /// No description provided for @category_western.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get category_western;

  /// No description provided for @explore_movies.
  ///
  /// In en, this message translates to:
  /// **'Explore Movies'**
  String get explore_movies;

  /// No description provided for @movies_title.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies_title;

  /// No description provided for @movie_list_content.
  ///
  /// In en, this message translates to:
  /// **'Movie List'**
  String get movie_list_content;

  /// No description provided for @all_movies.
  ///
  /// In en, this message translates to:
  /// **'All Movies'**
  String get all_movies;

  /// No description provided for @popular_movies.
  ///
  /// In en, this message translates to:
  /// **'Popular Movies'**
  String get popular_movies;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search movies...'**
  String get search_hint;

  /// No description provided for @search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'What do you want to watch?'**
  String get search_placeholder;

  /// No description provided for @search_button.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_button;

  /// No description provided for @clear_button.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear_button;

  /// No description provided for @no_movies_found.
  ///
  /// In en, this message translates to:
  /// **'No movies found'**
  String get no_movies_found;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknown_error;

  /// No description provided for @no_movies_in_category.
  ///
  /// In en, this message translates to:
  /// **'No movies found in this category'**
  String get no_movies_in_category;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// Search results message
  ///
  /// In en, this message translates to:
  /// **'Results for: \"{query}\"'**
  String search_results_for(String query);

  /// No search results message
  ///
  /// In en, this message translates to:
  /// **'No movies found for \"{query}\"'**
  String search_no_results(String query);

  /// No description provided for @search_type_to_search.
  ///
  /// In en, this message translates to:
  /// **'Type to search movies'**
  String get search_type_to_search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @movie_not_found.
  ///
  /// In en, this message translates to:
  /// **'Movie not found.'**
  String get movie_not_found;

  /// Movie rating
  ///
  /// In en, this message translates to:
  /// **'Rating: {rating}'**
  String rating(double rating);

  /// No description provided for @overview_title.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview_title;

  /// No description provided for @no_overview_available.
  ///
  /// In en, this message translates to:
  /// **'No overview available.'**
  String get no_overview_available;

  /// No description provided for @logout_title.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout_title;

  /// No description provided for @logout_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation_message;

  /// No description provided for @cancel_button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_button;

  /// No description provided for @watch_button.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch_button;

  /// No description provided for @more_info_button.
  ///
  /// In en, this message translates to:
  /// **'More Info'**
  String get more_info_button;

  /// No description provided for @no_movies_available.
  ///
  /// In en, this message translates to:
  /// **'No movies available'**
  String get no_movies_available;

  /// No description provided for @movie_information_title.
  ///
  /// In en, this message translates to:
  /// **'Movie Information'**
  String get movie_information_title;

  /// No description provided for @original_title_label.
  ///
  /// In en, this message translates to:
  /// **'Original Title'**
  String get original_title_label;

  /// No description provided for @release_date_label.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get release_date_label;

  /// No description provided for @language_label.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_label;

  /// No description provided for @popularity_label.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularity_label;

  /// No description provided for @content_rating_label.
  ///
  /// In en, this message translates to:
  /// **'Content Rating'**
  String get content_rating_label;

  /// No description provided for @adult_rating.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get adult_rating;

  /// No description provided for @unknown_genre.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown_genre;

  /// No description provided for @failed_to_load_avatars.
  ///
  /// In en, this message translates to:
  /// **'Failed to load avatars'**
  String get failed_to_load_avatars;

  /// No description provided for @failed_to_update_avatar.
  ///
  /// In en, this message translates to:
  /// **'Failed to update avatar'**
  String get failed_to_update_avatar;

  /// No description provided for @no_avatars_available.
  ///
  /// In en, this message translates to:
  /// **'No avatars available'**
  String get no_avatars_available;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get login_failed;

  /// No description provided for @validator_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get validator_enter_email;

  /// No description provided for @validator_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validator_valid_email;

  /// No description provided for @validator_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validator_enter_password;

  /// No description provided for @validator_password_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validator_password_length;

  /// No description provided for @registration_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registration_failed;

  /// No description provided for @validator_enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get validator_enter_name;

  /// No description provided for @validator_name_length.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get validator_name_length;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
