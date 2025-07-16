# Relatório de Atividades - Período 03/07/2025 a 10/07/2025

## Grupo 4
- Arthur Braga da Fonseca - 811461
- William Tsuyoshi Matsuda - 812305  
- Pedro Vinícius Guandalini Vicente - 812124

## Resumo das Atividades

Migração do aplicativo UFSCartaz de Kotlin/Jetpack Compose para Flutter, mantendo as funcionalidades originais.

## Principais Realizações

### 1. Estruturação do Projeto
- Criação do projeto Flutter
- Configuração do Retrofit para APIs (TMDB e Pexels)
- Implementação de navegação com go_router

### 2. Telas Implementadas
- Splash, Welcome, Login, Registration, Avatar Selection
- Home (listagem de filmes), Movie Detail
- Componentes: MovieCard, MovieList
- Telas bases feitas

### 3. Funcionalidades Mantidas
- Busca de filmes (TheMovieDB)
- Filtros por gênero
- Histórico de filmes
- Seleção de avatares (Pexels)
- Temas claro/escuro

### 4. Tecnologias Utilizadas
- **Estado**: Provider + RiverPod
- **Banco**: Floor (SQLite)
- **APIs**: Dio + Retrofit
- **Cache**: cached_network_image
- **Internacionalização**: flutter_localizations

### 5. Correções Técnicas
- Configuração NDK Android 29 (fix temporário) 
- Resolução de conflitos de assets
- Correção de temas (CardThemeData, TabBarThemeData)