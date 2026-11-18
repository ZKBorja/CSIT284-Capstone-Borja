class Team {
  Team({
    required this.id,
    required this.name,
    this.wins = 0,
    this.losses = 0,
  });

  final String id;
  final String name;
  int wins;
  int losses;
}