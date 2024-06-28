import 'dart:convert';
import 'package:http/http.dart' as http;


class ChemicalApiService {
  static const String baseUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug';

  Future<Map<String, dynamic>?> fetchCompoundDetails(String compoundName) async {
    try {
      print('Fetching CID for compound: $compoundName');
      final cidResponse = await http.get(
        Uri.parse('$baseUrl/compound/name/$compoundName/cids/JSON'),
      );

      if (cidResponse.statusCode != 200) {
        throw Exception('Failed to get CID for the given compound name.');
      }

      final cids = json.decode(cidResponse.body)['IdentifierList']['CID'];
      if (cids == null || cids.isEmpty) {
        throw Exception('No compound found for the given name.');
      }

      final cid = cids[0];
      print('Found CID: $cid');

      final compoundResponse = await http.get(
        Uri.parse('$baseUrl/compound/cid/$cid/record/JSON'),
      );

      if (compoundResponse.statusCode != 200) {
        throw Exception('Failed to fetch compound information.');
      }

      final compoundData = json.decode(compoundResponse.body);
      return compoundData['PC_Compounds']?.first;
    } catch (e) {
      print('Error fetching compound details: $e');
      return null;
    }
  }
}