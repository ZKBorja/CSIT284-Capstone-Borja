import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_borja/data/firebase_config.dart';
import 'package:capstone_borja/models/match_item.dart';
import 'package:capstone_borja/models/team.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({super.key, required this.teams});

  final List<Team> teams;

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  late Team _selectedTeamA;
  late Team _selectedTeamB;
  final _timeController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedTeamA = widget.teams[0];
    _selectedTeamB = widget.teams[1];
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  void _saveMatch() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTeamA.id == _selectedTeamB.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select two different teams.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final url = Uri.https(firebaseDomain, 'matches.json');
    String newId = DateTime.now().toString();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'teamAId': _selectedTeamA.id,
          'teamAName': _selectedTeamA.name,
          'teamBId': _selectedTeamB.id,
          'teamBName': _selectedTeamB.name,
          'scoreA': 0,
          'scoreB': 0,
          'time': _timeController.text.trim(),
          'status': 'Scheduled',
        }),
      );

      if (response.statusCode < 400 && response.body != 'null') {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['name'] != null) {
          newId = data['name'];
        }
      }
    } catch (_) {}

    if (!mounted) return;

    final newMatch = MatchItem(
      id: newId,
      teamA: _selectedTeamA,
      teamB: _selectedTeamB,
      time: _timeController.text.trim(),
      status: 'Scheduled',
    );

    Navigator.of(context).pop(newMatch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule New Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Team>(
                value: _selectedTeamA,
                decoration: const InputDecoration(
                  labelText: 'Select Team A',
                  border: OutlineInputBorder(),
                ),
                items: widget.teams
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTeamA = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Team>(
                value: _selectedTeamB,
                decoration: const InputDecoration(
                  labelText: 'Select Team B',
                  border: OutlineInputBorder(),
                ),
                items: widget.teams
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTeamB = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Schedule (e.g. Day 3 - 2:00 PM)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a schedule time.';
                  }
                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _saveMatch,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add Match'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}