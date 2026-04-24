import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/media_bloc.dart';
import '../bloc/media_event.dart';
import '../bloc/media_state.dart';
import '../widgets/media_grid.dart';
import 'search_page.dart';

enum MediaFilterType { movies, tvShows }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  Set<MediaFilterType> _activeFilters = {}; // Par défaut, aucun filtre (affiche tout)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCurrentTab();
  }

  void _loadCurrentTab() {
    if (_currentTabIndex == 0) {
      // Onglet Tendances
      if (_activeFilters.isEmpty || _activeFilters.length == 2) {
        // Aucun filtre ou les deux filtres = afficher tout (all)
        context.read<MediaBloc>().add(const GetTrendingEvent());
      } else if (_activeFilters.contains(MediaFilterType.movies)) {
        // Uniquement les films
        context.read<MediaBloc>().add(const GetTrendingMoviesEvent());
      } else {
        // Uniquement les séries
        context.read<MediaBloc>().add(const GetTrendingTvShowsEvent());
      }
    } else {
      // Onglet Populaires
      if (_activeFilters.isEmpty || _activeFilters.length == 2) {
        // Aucun filtre ou les deux filtres = afficher tout
        context.read<MediaBloc>().add(const GetPopularAllEvent());
      } else if (_activeFilters.contains(MediaFilterType.movies)) {
        // Uniquement les films
        context.read<MediaBloc>().add(const GetPopularMoviesEvent());
      } else {
        // Uniquement les séries
        context.read<MediaBloc>().add(const GetPopularTvShowsEvent());
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineMatch'),
        actions: [
          // Filtres Films et Séries
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilterChip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.movie, size: 16),
                    SizedBox(width: 4),
                    Text('Films'),
                  ],
                ),
                selected: _activeFilters.contains(MediaFilterType.movies),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _activeFilters.add(MediaFilterType.movies);
                    } else {
                      _activeFilters.remove(MediaFilterType.movies);
                    }
                  });
                  _loadCurrentTab();
                },
                showCheckmark: false,
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tv, size: 16),
                    SizedBox(width: 4),
                    Text('Séries'),
                  ],
                ),
                selected: _activeFilters.contains(MediaFilterType.tvShows),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _activeFilters.add(MediaFilterType.tvShows);
                    } else {
                      _activeFilters.remove(MediaFilterType.tvShows);
                    }
                  });
                  _loadCurrentTab();
                },
                showCheckmark: false,
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
              // Recharger les données quand on revient
              _loadCurrentTab();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
            _loadCurrentTab();
          },
          tabs: const [
            Tab(text: 'Tendances'),
            Tab(text: 'Populaires'),
          ],
        ),
      ),
      body: BlocBuilder<MediaBloc, MediaState>(
        builder: (context, state) {
          if (state is MediaLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MediaLoaded) {
            return MediaGrid(
              media: state.media,
              onMediaTap: _loadCurrentTab,
            );
          } else if (state is MediaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCurrentTab,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          // Pour MediaDetailsLoaded ou MediaInitial, afficher un message
          return const Center(child: Text('Bienvenue sur CineMatch'));
        },
      ),
    );
  }
}

