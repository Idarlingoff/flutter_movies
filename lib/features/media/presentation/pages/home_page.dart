import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import '../../../watchlist/presentation/pages/watchlist_page.dart';
import '../../../watched/presentation/pages/watched_page.dart';
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
  Set<MediaFilterType> _activeFilters = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCurrentTab();
  }

  void _loadCurrentTab() {
    if (_currentTabIndex == 0) {
      if (_activeFilters.isEmpty || _activeFilters.length == 2) {
        context.read<MediaBloc>().add(const GetTrendingEvent());
      } else if (_activeFilters.contains(MediaFilterType.movies)) {
        context.read<MediaBloc>().add(const GetTrendingMoviesEvent());
      } else {
        context.read<MediaBloc>().add(const GetTrendingTvShowsEvent());
      }
    } else {
      if (_activeFilters.isEmpty || _activeFilters.length == 2) {
        context.read<MediaBloc>().add(const GetPopularAllEvent());
      } else if (_activeFilters.contains(MediaFilterType.movies)) {
        context.read<MediaBloc>().add(const GetPopularMoviesEvent());
      } else {
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
            tooltip: 'Rechercher',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
              _loadCurrentTab();
            },
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.menu),
                tooltip: 'Menu',
                onSelected: (value) async {
                  switch (value) {
                    case 'favorites':
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesPage(),
                        ),
                      );
                      _loadCurrentTab();
                      break;
                    case 'watchlist':
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WatchlistPage(),
                        ),
                      );
                      _loadCurrentTab();
                      break;
                    case 'watched':
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WatchedPage(),
                        ),
                      );
                      _loadCurrentTab();
                      break;
                    case 'profile':
                      if (authState is Authenticated) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      } else {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                      _loadCurrentTab();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  final isAuthenticated = authState is Authenticated;

                  return [
                    PopupMenuItem<String>(
                      value: 'favorites',
                      enabled: isAuthenticated,
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: isAuthenticated ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Mes Favoris',
                            style: TextStyle(
                              color: isAuthenticated ? null : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'watchlist',
                      enabled: isAuthenticated,
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: isAuthenticated ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Ma Watchlist',
                            style: TextStyle(
                              color: isAuthenticated ? null : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'watched',
                      enabled: isAuthenticated,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: isAuthenticated ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Films Regardés',
                            style: TextStyle(
                              color: isAuthenticated ? null : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(
                            isAuthenticated
                                ? Icons.account_circle
                                : Icons.login,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isAuthenticated ? 'Mon Compte' : 'Se connecter',
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              );
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
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<MediaBloc, MediaState>(
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
              return const Center(child: Text('Bienvenue sur CineMatch'));
            },
          ),
          BlocBuilder<MediaBloc, MediaState>(
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
              return const Center(child: Text('Bienvenue sur CineMatch'));
            },
          ),
        ],
      ),
    );
  }
}

