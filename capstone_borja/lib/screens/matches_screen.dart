import 'package:flutter/material.dart';
import 'package:capstone_borja/models/match_item.dart';
import 'package:capstone_borja/models/team.dart';
import 'package:capstone_borja/screens/add_match_screen.dart';
import 'package:capstone_borja/screens/match_detail_screen.dart';
import 'package:capstone_borja/widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({
    super.key,
    required this.matches,
    required this.teams,
    required this.onUpdateMatch,
    required this.onAddMatch,
  });

  final List<MatchItem> matches;
  final List<Team> teams;
  final Function(MatchItem match, int scoreA, int scoreB, String status) onUpdateMatch;
  final Function(MatchItem newMatch) onAddMatch;

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  String _selectedFilter = 'All';

  void _openDetail(BuildContext context, MatchItem match) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (ctx) => MatchDetailScreen(match: match),
      ),
    );

    if (result != null) {
      widget.onUpdateMatch(
        match,
        result['scoreA'] as int,
        result['scoreB'] as int,
        result['status'] as String,
      );
    }
  }

  void _openAddMatch(BuildContext context) async {
    final newMatch = await Navigator.of(context).push<MatchItem>(
      MaterialPageRoute(
        builder: (ctx) => AddMatchScreen(teams: widget.teams),
      ),
    );

    if (newMatch != null) {
      widget.onAddMatch(newMatch);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMatches = widget.matches.where((match) {
      if (_selectedFilter == 'All') return true;
      return match.status == _selectedFilter;
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddMatch(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['All', 'Live', 'Scheduled', 'Finished'].map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredMatches.isEmpty
                ? const Center(child: Text('No matches found for this filter.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: filteredMatches.length,
                    itemBuilder: (ctx, index) {
                      final match = filteredMatches[index];
                      return MatchCard(
                        match: match,
                        onTap: () => _openDetail(context, match),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}