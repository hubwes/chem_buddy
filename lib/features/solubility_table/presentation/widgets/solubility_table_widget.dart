import 'package:flutter/material.dart';

class SolubilityTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotatedBox(
        quarterTurns: 1,
        child: Image.asset('assets/images/solubility_table.jpg'),
      ),
    );
  }
}
