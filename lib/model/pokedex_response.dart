import 'package:flutter/material.dart';
import 'package:pokedex/model/simple_pokemon.dart';

class PokedexResponse extends ChangeNotifier {
  String? nextPagination;
  String? previousPagination;
  List<SimplePokemonResponse> simplePokemonResponse = [];

  PokedexResponse({
    required this.nextPagination,
    required this.previousPagination,
    required this.simplePokemonResponse,
  });

  /// Factory permettant de construire un pokedex depuis une map de données récupérées depuis
  /// une API
  factory PokedexResponse.fromJson(Map<String, dynamic> json) {
    return PokedexResponse(
      nextPagination: json['next'],
      previousPagination: json['previous'],
      simplePokemonResponse: _jsonListToPokemonList(json['results']),
    );
  }

  static List<SimplePokemonResponse>_jsonListToPokemonList(List<dynamic> jsonList) {
    return jsonList.map((e) => SimplePokemonResponse.fromJson(e)).toList();
  }
}
