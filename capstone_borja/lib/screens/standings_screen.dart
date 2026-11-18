import 'package:flutter/material.dart';
import 'package:capstone_borja/models/team.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key, required this.teams});

  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    final sortedTeams = List<Team>.from(teams)
      ..sort((a, b) => b.wins.compareTo(a.wins));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Basketball Standings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Rank')),
              DataColumn(label: Text('Team')),
              DataColumn(label: Text('W')),
              DataColumn(label: Text('L')),
            ],
            rows: [
              for (int i = 0; i < sortedTeams.length; i++)
                DataRow(
                  cells: [
                    DataCell(Text('#${i + 1}')),
                    DataCell(
                      Text(
                        sortedTeams[i].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text(sortedTeams[i].wins.toString())),
                    DataCell(Text(sortedTeams[i].losses.toString())),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}