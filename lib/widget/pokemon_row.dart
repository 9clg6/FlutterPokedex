import 'package:flutter/material.dart';
import 'package:pokedex/model/managers/pokedex_manager.dart';

/// Widget permettant d'afficher le nom du pokémon ainsi que son numéro
class PokemonRow extends StatelessWidget {
  final PokedexManager pokedexManager;
  final int index;

  const PokemonRow({
    Key? key,
    required this.pokedexManager,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 250, 236, 193),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Image(
              image: AssetImage("assets/pokeball.png"),
              width: 25,
              height: 25,
            ),
          ),
          Expanded(
            child: Text("N°" + pokedexManager.pokedex.simplePokemonResponse.elementAt(index).id),
          ),
          Expanded(
            flex: 2,
            child: Text(
              pokedexManager.pokedex.simplePokemonResponse.elementAt(index).name.toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }
}
