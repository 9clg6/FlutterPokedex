import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/global.dart';

class PokemonDetailPage extends StatefulWidget {
  const PokemonDetailPage({Key? key}) : super(key: key);

  @override
  _PokemonDetailPageState createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  bool isBorderVisible = false;
  int tappedButton = -1;

  @override
  void initState() {
    /// Permet d'actualiser la fenêtre lorsque des données sont changées au sein du pokémon actuel
    pokedexManager.currentPokemon.addListener(() => setState(() => Null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  repeat: ImageRepeat.repeat,
                  opacity: 0.2,
                ),
              ),
            ),
            Column(
              children: [
                buildPokemonImageAndDetails(),
                buildButtonsRow(),
                buildBottomPanelWithButtons(context),
              ],
            ),
            Image.asset('assets/detailTopOverlay.png')
          ],
        ),
      ),
    );
  }

  /// Affiche l'image du pokémon et les détails de ce dernier
  Container buildPokemonImageAndDetails() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      color: const Color.fromARGB(255, 190, 215, 250).withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Stack(
              children: [
                const SizedBox(
                  width: 120,
                  height: 120,
                  child: Image(
                    image: AssetImage("assets/emptyCase.png"),
                  ),
                ),
                /// Image du pokémon
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Image(
                    image: NetworkImage(
                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" +
                          pokedexManager.currentPokemon.pokemonDetails!.id +
                          ".png",
                      scale: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (pokedexManager.currentPokemon.pokemonDetails != null)
            buildPokemonDetail()
          else
            const CircularProgressIndicator()
        ],
      ),
    );
  }

  Column buildPokemonDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 220,
          height: 50,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 250, 236, 193),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Image(
                      image: AssetImage("assets/pokeball.png"),
                      width: 25,
                      height: 25,
                    ),
                  ),
                  Expanded(
                    child: Text("N°" + pokedexManager.currentPokemon.pokemonDetails!.id),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      pokedexManager.currentPokemon.pokemonDetails!.name.toUpperCase(),
                    ),
                  ),
                ],
              )),
        ),
        /// Affichage des types du pokémon
        /// On récupère le type du pokémon via l'API et on va récupérer les images correpondantes
        /// en concatenant les données fixes et le nom du type du pokémon
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Wrap(
            children: List.generate(pokedexManager.currentPokemon.pokemonDetails!.listTypes.length,
                (index) {
              return Image(
                image: AssetImage(
                    "assets/${pokedexManager.currentPokemon.pokemonDetails!.listTypes.elementAt(index)}Type.png"),
                width: 100,
                height: 20,
              );
            }),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        /// Affichage des données du pokémon, comme sa taille et son poids
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("HAUT. "),
            Text(pokedexManager.currentPokemon.pokemonDetails!.height.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("POIDS "),
            Text(pokedexManager.currentPokemon.pokemonDetails!.weight.toString())
          ],
        ),
      ],
    );
  }

  /// Construction de l'interface contenant les boutons bleu permettant de sélectionner
  /// le pokémon suivant ou le pokémon précédant
  Expanded buildBottomPanelWithButtons(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color.fromARGB(255, 150, 93, 226),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              ///Chargement du pokémon précédent
              onTap: () {
                setState(() => pokedexManager.previousPokemon());
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "PRECED.",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.arrow_upward)
                  ],
                ),
                height: 100,
                width: 250,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 38, 238, 237),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 63, 53, 101),
                    width: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            InkWell(
              ///Chargement du pokémon suivant
              onTap: () => setState(() => pokedexManager.nextPokemon()),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "SUIVANT",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Icon(Icons.arrow_downward)
                  ],
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 38, 238, 237),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 63, 53, 101),
                    width: 4,
                  ),
                ),
                height: 100,
                width: 250,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Permet de construire la ligne contenant les différents boutons sur l'interface des détails
  /// du pokémon sélectionné
  Container buildButtonsRow() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      color: const Color.fromARGB(255, 173, 250, 134),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        /// Générations de la liste des boutons
        children: buildButtonWidgetList()
        ///Ajoute le dernier bouton, car il est différent des autres, via ".." q
        ///ui permet d'accéder à la liste des widget (children) et pas à la liste retourné
        ///par buildButtonWidgetList()
          ..add(
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 55,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 224, 136, 246),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: littleButtonBorderColor,
                    width: 2,
                  ),
                ),
                child: const RotatedBox(
                  quarterTurns: 3,
                  child: Icon(Icons.subdirectory_arrow_right),
                ),
              ),
            ),
          ),
      ),
    );
  }

  /// Génération des bordures de sélection lorsqu'on clique
  List<Widget> buildSelectionBorder(bool isBorderVisible){
    return [
      Visibility(
        visible: isBorderVisible,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: borderWidth,
            height: borderWidth,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: borderWeight, color: Colors.red),
                top: BorderSide(width: borderWeight, color: Colors.red),
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: isBorderVisible,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            width: borderWidth,
            height: borderWidth,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: borderWeight, color: Colors.red),
                top: BorderSide(width: borderWeight, color: Colors.red),
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: isBorderVisible,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: borderWidth,
            height: borderWidth,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: borderWeight, color: Colors.red),
                bottom: BorderSide(width: borderWeight, color: Colors.red),
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: isBorderVisible,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: borderWidth,
            height: borderWidth,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: borderWeight, color: Colors.red),
                bottom: BorderSide(width: borderWeight, color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> buildButtonWidgetList() {
    /// Génération des boutons via une liste de constants (texte)
    return List.generate(
      buttonTextList.length,
      (index) {
        /// InkWell permet de créer de l'intéraction avec n'importe quel Widget existant.
        /// Dans notre cas, InkWell permet de créer une action au touché sur le Widget (onTap)
        ///
        return InkWell(
          onTap: () {
            setState(() {
              tappedButton = index;
              isBorderVisible = true;
            });
          },
          child: SizedBox(
            width: littleButtonWidth,
            height: littleButtonHeight,
            /// Stack permet de superposer les bordures, qui sont sont construites via plusieurs container
            /// sur les boutons.
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: littleButtonWidth,
                  height: littleButtonHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: littleButtonBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: littleButtonBorderColor,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    buttonTextList.elementAt(index),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                /// Utilisation du spread opérator pour ajouter chacun des élements de la liste
                /// à la liste des enfants
                ///
                /// children prend soit une liste, soit une méthode retournant une liste.
                /// Donc lorsque les enfants sont définis via [], on ne peut pas mettre la
                /// méthode retournant une liste dans les crochets. Sinon ça donnerait une List<List<Widget>>
                /// Le spread operator permet de prendre chacun de les élements et les mettre individuellement
                /// à l'intérieur de la liste.
                ///
                /// Les bordures sont affichées que si l'index du bouton sélectionné correspond
                /// à l'index actuel du bouton
                if(tappedButton == index) ...buildSelectionBorder(isBorderVisible),
              ],
            ),
          ),
        );
      },
    );
  }
}
