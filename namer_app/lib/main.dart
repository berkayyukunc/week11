import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyan,
            brightness: Brightness.dark,
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      // Mobile layout (narrow screen)
      if (constraints.maxWidth < 600) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D0D1A),
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                ],
              ),
            ),
            child: page,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Color(0xFF0D0D1A),
              border: Border(
                top: BorderSide(
                  color: Colors.cyanAccent.withOpacity(0.15),
                  width: 1,
                ),
              ),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              indicatorColor: Colors.cyanAccent.withOpacity(0.15),
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.auto_awesome_outlined,
                      color: Colors.white38),
                  selectedIcon:
                      Icon(Icons.auto_awesome, color: Colors.cyanAccent),
                  label: 'Generate',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border, color: Colors.white38),
                  selectedIcon:
                      Icon(Icons.favorite, color: Colors.pinkAccent),
                  label: 'Favorites',
                ),
              ],
            ),
          ),
        );
      }

      // Desktop layout (wide screen)
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D0D1A),
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
              ],
            ),
          ),
          child: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  backgroundColor: Colors.transparent,
                  extended: constraints.maxWidth >= 800,
                  indicatorColor: Colors.cyan.withOpacity(0.2),
                  selectedIconTheme: IconThemeData(
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  unselectedIconTheme:
                      IconThemeData(color: Colors.white38),
                  selectedLabelTextStyle: TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelTextStyle:
                      TextStyle(color: Colors.white38),
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_awesome_outlined),
                      selectedIcon: Icon(Icons.auto_awesome),
                      label: Text('Generate'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(child: page),
            ],
          ),
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '✨ WORD GENERATOR',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 30),
            BigCard(pair: pair),
            SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildNeonButton(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon, size: 18),
                  label: 'Like',
                  isActive: appState.favorites.contains(pair),
                  activeColor: Colors.pinkAccent,
                ),
                _buildNeonButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  icon: Icon(Icons.skip_next_rounded, size: 18),
                  label: 'Next',
                  isActive: false,
                  activeColor: Colors.cyanAccent,
                ),
              ],
            ),
            SizedBox(height: 30),
            if (appState.favorites.isNotEmpty)
              Text(
                '${appState.favorites.length} word${appState.favorites.length > 1 ? 's' : ''} saved',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeonButton({
    required VoidCallback onPressed,
    required Icon icon,
    required String label,
    required bool isActive,
    required Color activeColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? activeColor.withOpacity(0.6)
              : Colors.white12,
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withOpacity(0.2),
                  blurRadius: 12,
                ),
              ]
            : [],
      ),
      child: Material(
        color: isActive
            ? activeColor.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: isActive ? activeColor : Colors.white54,
                  ),
                  child: icon,
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? activeColor : Colors.white54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.cyan.withOpacity(0.15),
            Colors.purple.withOpacity(0.15),
          ],
        ),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.1),
            blurRadius: 30,
          ),
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.05),
            blurRadius: 50,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
        child: Text(
          pair.asLowerCase,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: Colors.cyanAccent.withOpacity(0.5),
                blurRadius: 20,
              ),
            ],
          ),
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 48, color: Colors.white12),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(color: Colors.white24, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the Like button to save words',
              style: TextStyle(color: Colors.white12, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.pinkAccent, size: 20),
                SizedBox(width: 10),
                Text(
                  'Favorites',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.pinkAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${appState.favorites.length}',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: appState.favorites.length,
              itemBuilder: (context, index) {
                var pair = appState.favorites[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pinkAccent.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.pinkAccent,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      pair.asLowerCase,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
