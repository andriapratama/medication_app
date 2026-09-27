import 'package:flutter/material.dart';

// TEMPORARY placeholder until Phase 6.3; shows the id received from the route.
class MedicationDetailScreen extends StatelessWidget {
  final String id;

  const MedicationDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(id)),
    );
  }
}
