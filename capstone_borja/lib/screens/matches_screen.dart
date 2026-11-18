import 'package:flutter/material.dart';
import 'package:capstone_borja/models/match_item.dart';
import 'package:capstone_borja/screens/match_detail_screen.dart';
import 'package:capstone_borja/widgets/match_card.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    super.key,
    required this.matches,
    required this.onUpdateMatch,
  });

  final List<MatchItem> matches;
  final Function(MatchItem match, int scoreA, int scoreB, String status) onUpdateMatch;

  void _openDetail(BuildContext context, MatchItem match) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (ctx) => MatchDetailScreen(match: match),
      ),
    );

    if (result != null) {
      onUpdateMatch(
        match,
        result['scoreA'] as int,
        result['scoreB'] as int,
        result['status'] as String,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: matches.length,
      itemBuilder: (ctx, index) {
        final match = matches[index];
        return MatchCard(
          match: match,
          onTap: () => _openDetail(context, match),
        );
      },
    );
  }
}