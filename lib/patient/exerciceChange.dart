import 'package:flutter/material.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  String selectedFilter = 'Tout'; // Default filter

  void setFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterChip(
                label: Text('All'),
                selected: selectedFilter == 'All',
                onSelected: (isSelected) {
                  setFilter('All');
                },
              ),
              SizedBox(width: 10),
              FilterChip(
                label: Text('Physique'),
                selected: selectedFilter == 'Physical',
                onSelected: (isSelected) {
                  setFilter('Physical');
                },
              ),
              SizedBox(width: 10),
              FilterChip(
                label: Text('Cognitif'),
                selected: selectedFilter == 'Cognitive',
                onSelected: (isSelected) {
                  setFilter('Cognitif');
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                if (selectedFilter == 'All' ||
                    exercise.type == selectedFilter) {
                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text('Type: ${exercise.type}'),
                    // Add more details here as needed
                  );
                }
                return SizedBox
                    .shrink(); // Hide exercises not matching the filter
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Exercise {
  final String name;
  final String type;

  Exercise({required this.name, required this.type});
}

List<Exercise> exercises = [
  Exercise(name: 'Push-ups', type: 'Physical'),
  Exercise(name: 'Memory Game', type: 'Cognitive'),
  Exercise(name: 'Running', type: 'Physical'),
  Exercise(name: 'Sudoku', type: 'Cognitive'),
  // Add more exercises here
];
