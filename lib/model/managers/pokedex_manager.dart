import 'package:pokedex/model/detailed_pokemon.dart';
import 'package:pokedex/model/pokedex_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokedex/global.dart';
import 'package:pokedex/model/simple_pokemon.dart';

class PokedexManager with ChangeNotifier {
  SimplePokemonResponse currentPokemon = SimplePokemonResponse(detailUrl: "https://pokeapi.co/api/v2/pokemon/1", name: "bulbasaur");
  late PokedexResponse pokedex;
  int index = 0;

  /// Utilisation du change Notifier permettant de notifié les abonnés lors d'un changement, donc
  /// fait un setState lorsqu'un attribut est modifié
  /// Quand le currentPokemon est le dernier élement de la liste, charge la prochaine page
  void nextPokemon(){
    if(index+1<pokedex.simplePokemonResponse.length){
      index++;
      setCurrentPokemon(pokedex.simplePokemonResponse.elementAt(index));
      notifyListeners();
    } else {
      addNextPokedexPage(pokedex.nextPagination!);
    }
  }

  void previousPokemon(){
    if(index-1 != 0){
      index--;
      setCurrentPokemon(pokedex.simplePokemonResponse.elementAt(index));
      notifyListeners();
    }
  }

  void setDetail(DetailedPokemon p){
    currentPokemon.pokemonDetails = p;
    notifyListeners();
  }

  void initializePokedex(PokedexResponse p){
    pokedex = p;
    notifyListeners();
  }

  void setCurrentPokemon(SimplePokemonResponse c) async {
    /// Si le pokemon actuel n'a pas ses détails de définis, appelle le get pour obtenir
    /// les détails
    /// Le ??= correspond à un if(pokemonDetail == null){}
    c.pokemonDetails ??= await c.getPokemonDetails();
    currentPokemon = c;
    notifyListeners();
  }

  /// Ajoute la page suivantes de pokémons à la liste des pokémons
  Future<void> addNextPokedexPage(String url) async {
    PokedexResponse pokedexResponse = await apiManager.fetchAllData(url);

    pokedex.nextPagination = pokedexResponse.nextPagination;
    pokedex.previousPagination = pokedexResponse.previousPagination;
    pokedex.simplePokemonResponse.addAll(pokedexResponse.simplePokemonResponse);

    notifyListeners();
  }
}