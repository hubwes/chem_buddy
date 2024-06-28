import 'package:chem_buddy/features/quiz/presentation/pages/main_quiz_page.dart';
import 'package:chem_buddy/features/solubility_table/presentation/pages/solubility_main_page.dart';
import 'package:flutter/material.dart';
import 'package:chem_buddy/features/periodic_table/presentation/pages/periodic_table_page.dart';
import 'package:chem_buddy/features/mass_calculator/presentation/pages/mass_calculator_page.dart';
import 'package:chem_buddy/features/concentration_calculator/presentation/pages/concentration_calculator_page.dart';
import 'package:chem_buddy/features/chemical_reaction_calculator/presentation/pages/chemical_reaction_calculator_page.dart';
import 'package:chem_buddy/features/unit_converter/presentation/pages/unit_converter_page.dart';
import 'package:chem_buddy/features/notes/presentation/pages/notes_page.dart';
import 'package:chem_buddy/features/notes/presentation/pages/graph_page.dart';
import 'package:chem_buddy/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../info_api/presentation/pages/main_search_page.dart';

class WelcomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('welcome'),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildElevatedButton(
                context,
                label: localizations.translate('periodic_table'),
                icon: Icons.table_chart,
                page: PeriodicTablePage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('mass_calculator'),
                icon: Icons.calculate,
                page: MassCalculatorPage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('concentration_calculator'),
                icon: Icons.science,
                page: ConcentrationCalculatorPage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('reactions'),
                icon: Icons.autorenew,
                page: ChemicalReactionCalculatorPage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('unit_converter'),
                icon: Icons.swap_horiz,
                page: UnitConverterPage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('notes'),
                icon: Icons.note,
                page: NotesPage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('solubility'),
                icon: Icons.opacity,
                page: SolubilityMainPage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('create_new_graph'),
                icon: Icons.show_chart,
                page: GraphPage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('quiz'),
                icon: Icons.quiz,
                page: MainQuizPage(),
                width: buttonWidth,
              ),
              _buildElevatedButton(
                context,
                label: localizations.translate('chemical_search'),
                icon: Icons.search,
                page: MainSearchPage(),
                width: buttonWidth,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context,
      {required String label, required IconData icon, required Widget page, required double width}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(// Color when button is disabled
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          minimumSize: Size(width, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
