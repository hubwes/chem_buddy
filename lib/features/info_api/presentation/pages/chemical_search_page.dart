import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chem_buddy/features/info_api/presentation/providers/chemical_api_provider.dart';
import 'package:chem_buddy/features/info_api/presentation/providers/search_history_provider.dart';
import 'package:chem_buddy/features/info_api/services/search_history_service.dart';

class ChemicalSearchPage extends ConsumerStatefulWidget {
  final Function(String) onSearch;
  final String searchTerm;

  ChemicalSearchPage({required this.onSearch, required this.searchTerm});

  @override
  _ChemicalSearchPageState createState() => _ChemicalSearchPageState();
}

class _ChemicalSearchPageState extends ConsumerState<ChemicalSearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.searchTerm.isNotEmpty) {
      _controller.text = widget.searchTerm;
      ref.read(compoundProvider(widget.searchTerm));
    }
  }

  @override
  Widget build(BuildContext context) {
    final compoundAsyncValue = ref.watch(compoundProvider(widget.searchTerm));

    return Scaffold(
      appBar: AppBar(
        title: Text('Chemical Search'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter compound name',
                labelStyle: TextStyle(color: Colors.deepOrange),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.deepOrange),
                  onPressed: () async {
                    widget.onSearch(_controller.text);
                    final searchHistoryService = ref.read(searchHistoryServiceProvider);
                    await searchHistoryService.addSearchHistory(_controller.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: compoundAsyncValue.when(
                data: (compound) {
                  if (compound == null) {
                    return Center(child: Text('Compound not found'));
                  } else {
                    return ListView(
                      children: [
                        ListTile(
                          title: Text('Molecular Formula'),
                          subtitle: Text(compound.molecularFormula),
                        ),
                        ListTile(
                          title: Text('Molecular Weight'),
                          subtitle: Text(compound.molecularWeight.toString()),
                        ),
                        ListTile(
                          title: Text('Canonical SMILES'),
                          subtitle: Text(compound.canonicalSMILES),
                        ),
                        if (compound.iupacName != null)
                          ListTile(
                            title: Text('IUPAC Name'),
                            subtitle: Text(compound.iupacName!),
                          ),
                        if (compound.inchi != null)
                          ListTile(
                            title: Text('InChI'),
                            subtitle: Text(compound.inchi!),
                          ),
                        if (compound.inchiKey != null)
                          ListTile(
                            title: Text('InChIKey'),
                            subtitle: Text(compound.inchiKey!),
                          ),
                        if (compound.xlogp3 != null)
                          ListTile(
                            title: Text('XLogP3'),
                            subtitle: Text(compound.xlogp3.toString()),
                          ),
                        if (compound.exactMass != null)
                          ListTile(
                            title: Text('Exact Mass'),
                            subtitle: Text(compound.exactMass.toString()),
                          ),
                        if (compound.topologicalPolarSurfaceArea != null)
                          ListTile(
                            title: Text('Topological Polar Surface Area'),
                            subtitle: Text(compound.topologicalPolarSurfaceArea.toString()),
                          ),
                        if (compound.complexity != null)
                          ListTile(
                            title: Text('Complexity'),
                            subtitle: Text(compound.complexity.toString()),
                          ),
                        if (compound.hydrogenBondDonorCount != null)
                          ListTile(
                            title: Text('Hydrogen Bond Donor Count'),
                            subtitle: Text(compound.hydrogenBondDonorCount.toString()),
                          ),
                        if (compound.hydrogenBondAcceptorCount != null)
                          ListTile(
                            title: Text('Hydrogen Bond Acceptor Count'),
                            subtitle: Text(compound.hydrogenBondAcceptorCount.toString()),
                          ),
                        if (compound.rotatableBondCount != null)
                          ListTile(
                            title: Text('Rotatable Bond Count'),
                            subtitle: Text(compound.rotatableBondCount.toString()),
                          ),
                      ],
                    );
                  }
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
