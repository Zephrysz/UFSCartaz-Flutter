// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get app_name => 'UFSCARTAZ';

  @override
  String get logo_part1 => 'UFSCAR';

  @override
  String get logo_part2 => 'TAZ';

  @override
  String get welcome_subtitle => 'Entretenimento sem fim, tudo em um lugar';

  @override
  String get button_register => 'CADASTRAR';

  @override
  String get button_login => 'ENTRAR';

  @override
  String get auth_welcome_back => 'Bem-vindo de volta!';

  @override
  String get auth_welcome => 'Bem-vindo!';

  @override
  String get label_name => 'Nome';

  @override
  String get label_email => 'E-mail';

  @override
  String get label_password => 'Senha';

  @override
  String get title_choose_avatar => 'Escolher avatar';

  @override
  String get button_skip => 'Pular';

  @override
  String get label_avatar => 'Avatar';

  @override
  String get button_continue => 'Continuar';

  @override
  String get avatar_selection_placeholder =>
      'Opções de avatar apareceriam aqui';

  @override
  String get recently_viewed => 'Vistos Recentemente';

  @override
  String home_greeting(String username) {
    return 'Para você, $username';
  }

  @override
  String get default_user_name => 'Usuário';

  @override
  String get content_description_user_avatar => 'Avatar do usuário';

  @override
  String get category_documentaries => 'Documentários';

  @override
  String get category_comedy => 'Comédia';

  @override
  String get category_drama => 'Drama';

  @override
  String get category_action => 'Ação';

  @override
  String get category_adventure => 'Aventura';

  @override
  String get category_horror => 'Terror';

  @override
  String get category_scifi => 'Ficção Científica';

  @override
  String get category_romance => 'Romance';

  @override
  String get category_animation => 'Animação';

  @override
  String get category_crime => 'Crime';

  @override
  String get category_family => 'Família';

  @override
  String get category_fantasy => 'Fantasia';

  @override
  String get category_history => 'História';

  @override
  String get category_music => 'Música';

  @override
  String get category_mystery => 'Mistério';

  @override
  String get category_tv_movie => 'Filme de TV';

  @override
  String get category_thriller => 'Thriller';

  @override
  String get category_war => 'Guerra';

  @override
  String get category_western => 'Faroeste';

  @override
  String get explore_movies => 'Explorar Filmes';

  @override
  String get movies_title => 'Filmes';

  @override
  String get movie_list_content => 'Lista de Filmes';

  @override
  String get all_movies => 'Todos os Filmes';

  @override
  String get popular_movies => 'Filmes Populares';

  @override
  String get search_hint => 'Buscar filmes...';

  @override
  String get search_placeholder => 'O que você quer assistir?';

  @override
  String get search_button => 'Buscar';

  @override
  String get clear_button => 'Limpar';

  @override
  String get no_movies_found => 'Nenhum filme encontrado';

  @override
  String get try_again => 'Tentar novamente';

  @override
  String get unknown_error => 'Erro desconhecido';

  @override
  String get no_movies_in_category => 'Nenhum filme encontrado nesta categoria';

  @override
  String get movies => 'Filmes';

  @override
  String search_results_for(String query) {
    return 'Resultados para: \"$query\"';
  }

  @override
  String search_no_results(String query) {
    return 'Nenhum filme encontrado para \"$query\"';
  }

  @override
  String get search_type_to_search => 'Digite para pesquisar filmes';

  @override
  String get loading => 'Carregando...';

  @override
  String get back => 'Voltar';

  @override
  String get movie_not_found => 'Filme não encontrado.';

  @override
  String rating(double rating) {
    final intl.NumberFormat ratingNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String ratingString = ratingNumberFormat.format(rating);

    return 'Avaliação: $ratingString';
  }

  @override
  String get overview_title => 'Sinopse';

  @override
  String get no_overview_available => 'Sinopse não disponível.';

  @override
  String get logout_title => 'Sair';

  @override
  String get logout_confirmation_message => 'Tem certeza de que deseja sair?';

  @override
  String get cancel_button => 'Cancelar';

  @override
  String get watch_button => 'Assistir';

  @override
  String get more_info_button => 'Mais Info';

  @override
  String get no_movies_available => 'Nenhum filme disponível';

  @override
  String get movie_information_title => 'Informações do Filme';

  @override
  String get original_title_label => 'Título Original';

  @override
  String get release_date_label => 'Data de Lançamento';

  @override
  String get language_label => 'Idioma';

  @override
  String get popularity_label => 'Popularidade';

  @override
  String get content_rating_label => 'Classificação';

  @override
  String get adult_rating => 'Adulto';

  @override
  String get unknown_genre => 'Desconhecido';

  @override
  String get failed_to_load_avatars => 'Falha ao carregar avatares';

  @override
  String get failed_to_update_avatar => 'Falha ao atualizar o avatar';

  @override
  String get no_avatars_available => 'Nenhum avatar disponível';

  @override
  String get login_failed => 'Falha no login. Verifique suas credenciais.';

  @override
  String get validator_enter_email => 'Por favor, insira seu e-mail';

  @override
  String get validator_valid_email => 'Por favor, insira um e-mail válido';

  @override
  String get validator_enter_password => 'Por favor, insira sua senha';

  @override
  String get validator_password_length =>
      'A senha deve ter no mínimo 6 caracteres';

  @override
  String get registration_failed =>
      'Falha no cadastro. Por favor, tente novamente.';

  @override
  String get validator_enter_name => 'Por favor, insira seu nome';

  @override
  String get validator_name_length => 'O nome deve ter no mínimo 2 caracteres';
}
