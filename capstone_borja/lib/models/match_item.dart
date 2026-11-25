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

  Map<String, dynamic> toJson() {
    return {
      'teamAId': teamA.id,
      'teamAName': teamA.name,
      'teamBId': teamB.id,
      'teamBName': teamB.name,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'time': time,
      'status': status,
    };
  }

  factory MatchItem.fromJson(String id, Map<String, dynamic> json) {
    return MatchItem(
      id: id,
      teamA: Team(id: json['teamAId'] ?? '', name: json['teamAName'] ?? 'Team A'),
      teamB: Team(id: json['teamBId'] ?? '', name: json['teamBName'] ?? 'Team B'),
      scoreA: json['scoreA'] ?? 0,
      scoreB: json['scoreB'] ?? 0,
      time: json['time'] ?? '',
      status: json['status'] ?? 'Scheduled',
    );
  }
}