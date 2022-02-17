import 'package:flutter/cupertino.dart';
import 'package:pokedex/global.dart';
import 'package:pokedex/model/detailed_pokemon.dart';

class SimplePokemonResponse with ChangeNotifier {
  String id = "0";
  String name;
  String detailUrl;
  DetailedPokemon? pokemonDetails;

  /// Création de l'id via le parsing de l'url
  SimplePokemonResponse({required this.name, required this.detailUrl}) {
    var regexResult = RegExp("/[0-9]+/").stringMatch(detailUrl);
    if (regexResult != null) id = regexResult.toString().replaceAll("/", "");
  }

  Future<DetailedPokemon> getPokemonDetails() async {
    return await apiManager.fetchDetailData(detailUrl, id);
  }

  factory SimplePokemonResponse.fromJson(Map<String, dynamic> json) {
    return SimplePokemonResponse(
      name: json['name'],
      detailUrl: json['url'],
    );
  }
}
