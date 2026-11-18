import 'package:flutter/material.dart';
import 'package:capstone_borja/models/match_item.dart';

class MatchDetailScreen extends StatefulWidget {
  const MatchDetailScreen({super.key, required this.match});

  final MatchItem match;

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  late final TextEditingController _scoreAController;
  late final TextEditingController _scoreBController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _scoreAController = TextEditingController(text: widget.match.scoreA.toString());
    _scoreBController = TextEditingController(text: widget.match.scoreB.toString());
    _selectedStatus = widget.match.status;
  }

  @override
  void dispose() {
    _scoreAController.dispose();
    _scoreBController.dispose();
    super.dispose();
  }

  void _save() {
    final scoreA = int.tryParse(_scoreAController.text) ?? widget.match.scoreA;
    final scoreB = int.tryParse(_scoreBController.text) ?? widget.match.scoreB;

    Navigator.of(context).pop({
      'scoreA': scoreA,
      'scoreB': scoreB,
      'status': _selectedStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details & Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${widget.match.teamA.name} vs ${widget.match.teamB.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.match.time, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(
              controller: _scoreAController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${widget.match.teamA.name} Score',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _scoreBController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${widget.match.teamB.name} Score',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Match Status',
                border: OutlineInputBorder(),
              ),
              items: ['Scheduled', 'Live', 'Finished']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStatus = val!;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save & Update Score'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}