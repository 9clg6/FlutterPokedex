import 'dart:convert';
import 'package:http/http.dart';
import 'package:pokedex/model/detailed_pokemon.dart';
import 'package:pokedex/model/pokedex_response.dart';
import 'package:pokedex/utils/debug_logger.dart';

class APIManager {
  /// Méthode générique d'appel d'API
  Future<Map<String, dynamic>> _fetchData(String apiAddress) async {
    final response = await get(Uri.parse(apiAddress));

    if(response.statusCode == 200){
      DebugLogger.debugLog("api_manager", "fetchData()", "FetchData ✅", 3);
      return jsonDecode(response.body);
    } else {
      DebugLogger.debugLog("api_manager", "fetchData()", "FetchData ❌", 1);
      throw Exception("Failed to load pokedex");
    }
  }

  /// Méthode spécifique permettant d'obtenir toutes les données des pokémons
  Future<PokedexResponse> fetchAllData(String apiAddress) async {
    return PokedexResponse.fromJson(await _fetchData(apiAddress));
  }

  /// Méthode spécifique permettant d'obtenir les détails des pokémons
  Future<DetailedPokemon> fetchDetailData(String pokemonAddress, String id) async {
    return DetailedPokemon.fromJson(await _fetchData(pokemonAddress), id);
  }
}