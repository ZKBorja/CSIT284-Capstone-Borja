import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_borja/data/dummy_data.dart';
import 'package:capstone_borja/data/firebase_config.dart';
import 'package:capstone_borja/models/match_item.dart';
import 'package:capstone_borja/models/team.dart';
import 'package:capstone_borja/screens/matches_screen.dart';
import 'package:capstone_borja/screens/standings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Intrams Scoreboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  bool _isLoading = true;

  final List<Team> _teams = dummyTeams;
  List<MatchItem> _matches = [];

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  void _loadMatches() async {
    final url = Uri.https(firebaseDomain, 'matches.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400 || response.body == 'null') {
        setState(() {
          _matches = dummyMatches;
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List<MatchItem> loadedMatches = [];

      for (final entry in data.entries) {
        loadedMatches.add(MatchItem.fromJson(entry.key, entry.value));
      }

      setState(() {
        _matches = loadedMatches;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _matches = dummyMatches;
        _isLoading = false;
      });
    }
  }

  void _addMatch(MatchItem newMatch) {
    setState(() {
      _matches.add(newMatch);
    });
  }

  void _deleteMatch(MatchItem match) async {
    final index = _matches.indexOf(match);
    setState(() {
      _matches.remove(match);
    });

    final url = Uri.https(firebaseDomain, 'matches/${match.id}.json');
    try {
      await http.delete(url);
    } catch (_) {
      setState(() {
        _matches.insert(index, match);
      });
    }
  }

  void _updateScore(MatchItem match, int newScoreA, int newScoreB, String newStatus) {
    setState(() {
      match.scoreA = newScoreA;
      match.scoreB = newScoreB;

      if (match.status != 'Finished' && newStatus == 'Finished') {
        if (newScoreA > newScoreB) {
          match.teamA.wins++;
          match.teamB.losses++;
        } else if (newScoreB > newScoreA) {
          match.teamB.wins++;
          match.teamA.losses++;
        }
      }

      match.status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final pages = [
      MatchesScreen(
        matches: _matches,
        teams: _teams,
        onUpdateMatch: _updateScore,
        onAddMatch: _addMatch,
        onDeleteMatch: _deleteMatch,
      ),
      StandingsScreen(
        teams: _teams,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intramurals 2024'),
        centerTitle: true,
      ),
      body: pages[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Standings',
          ),
        ],
      ),
    );
  }
}