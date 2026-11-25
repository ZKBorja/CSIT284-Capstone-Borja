import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_borja/data/firebase_config.dart';
import 'package:capstone_borja/models/match_item.dart';

class MatchDetailScreen extends StatefulWidget {
  const MatchDetailScreen({super.key, required this.match});

  final MatchItem match;

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  late int _scoreA;
  late int _scoreB;
  late String _selectedStatus;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _scoreA = widget.match.scoreA;
    _scoreB = widget.match.scoreB;
    _selectedStatus = widget.match.status;
  }

  void _save() async {
    setState(() {
      _isSaving = true;
    });

    final url = Uri.https(firebaseDomain, 'matches/${widget.match.id}.json');

    try {
      await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'scoreA': _scoreA,
          'scoreB': _scoreB,
          'status': _selectedStatus,
        }),
      );
    } catch (_) {}

    if (!mounted) return;

    Navigator.of(context).pop({
      'action': 'update',
      'scoreA': _scoreA,
      'scoreB': _scoreB,
      'status': _selectedStatus,
    });
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Match'),
        content: const Text('Are you sure you want to delete this match?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isSaving = true;
    });

    final url = Uri.https(firebaseDomain, 'matches/${widget.match.id}.json');

    try {
      await http.delete(url);
    } catch (_) {}

    if (!mounted) return;

    Navigator.of(context).pop({
      'action': 'delete',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Score Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isSaving ? null : _delete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.match.time,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      widget.match.teamA.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_scoreA',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => setState(() => _scoreA += 1),
                          child: const Text('+1'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => setState(() => _scoreA += 2),
                          child: const Text('+2'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => setState(() => _scoreA += 3),
                          child: const Text('+3'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      widget.match.teamB.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_scoreB',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => setState(() => _scoreB += 1),
                          child: const Text('+1'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => setState(() => _scoreB += 2),
                          child: const Text('+2'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => setState(() => _scoreB += 3),
                          child: const Text('+3'),
                        ),
                      ],
                    ),
                  ],
                ),
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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}