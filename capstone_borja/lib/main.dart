import 'package:flutter/material.dart';
import 'package:capstone_borja/data/dummy_data.dart';
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

  final List<Team> _teams = dummyTeams;
  final List<MatchItem> _matches = dummyMatches;

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
    final pages = [
      MatchesScreen(
        matches: _matches,
        onUpdateMatch: _updateScore,
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