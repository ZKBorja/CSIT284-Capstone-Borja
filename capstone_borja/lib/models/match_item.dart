import 'package:capstone_borja/models/team.dart';

class MatchItem {
  MatchItem({
    required this.id,
    required this.teamA,
    required this.teamB,
    this.scoreA = 0,
    this.scoreB = 0,
    required this.time,
    this.status = 'Scheduled',
  });

  final String id;
  final Team teamA;
  final Team teamB;
  int scoreA;
  int scoreB;
  final String time;
  String status;
}