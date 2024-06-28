import 'package:flutter/material.dart';

class SolubilityTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solubility Table'),
      ),
      body: Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: Image.asset('assets/images/solubility_table.jpg'),
        ),
      ),
    );
  }
}
