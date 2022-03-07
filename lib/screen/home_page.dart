import 'package:pokedex/global.dart';
import 'package:pokedex/model/detailed_pokemon.dart';
import 'package:pokedex/model/managers/pokedex_manager.dart';
import 'package:pokedex/screen/pokemon_detail_page.dart';
import 'package:pokedex/utils/debug_logger.dart';
import 'package:pokedex/widget/pokemon_row.dart';
import 'package:pokedex/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FixedExtentScrollController _controller;
  late SharedPreferences sharePref;
  int index = 0;
  double _angle = 0.0;
  double _oldAngle = 0.0;
  double _angleDelta = 0.0;

  @override
  void initState() {
    _controller = FixedExtentScrollController(initialItem: index);
    pokedexManager.addListener(() => setState(() => Null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          sharePref = snapshot.data! as SharedPreferences;
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 246, 233, 162),
              body: Stack(
                children: [
                  Column(
                    children: [
                      buildPokemonsListAndImage(),
                      buildMiddleOverlay(),
                      buildScrollPokeballAndButtons(),
                    ],
                  ),
                  buildTopOverlay(context),
                  buildRedCursor(),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Padding buildRedCursor() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, left: 190),
      child: Container(
        height: 52,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildMiddleOverlay() {
    return Stack(
      children: [
        const Image(image: AssetImage("assets/bottomOverlay.png")),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "POKéDEX DE ${sharePref.getString('nickname')}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Création de la ligne contenant la pokeball scrollable et les boutons de navigation
  Expanded buildScrollPokeballAndButtons() {
    /// Expanded permet d'occuper la surface restante de l'écran
    return Expanded(
      child: Row(
        children: [
          /// Création de la column contenant les boutons à gauche
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: buildBigButtonsColumn(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 70.0, bottom: 70, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 220, 140),
                  border: Border.all(
                    color: const Color.fromARGB(255, 230, 180, 110),
                    width: 3,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                  right: 4,
                  left: 4,
                ),
                child: buildPokedexNavigationButtonsColumn(),
              ),
            ),
          ),
          buildPokeballScroll(),
        ],
      ),
    );
  }

  Expanded buildPokeballScroll() {
    return Expanded(
        flex: 3,
        child: LayoutBuilder(
          builder: (context, constraints) {
            Offset centerOfGestureDetector = Offset(constraints.maxWidth / 2, 130);
            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Transform.rotate(
                    angle: _angle,
                    child: const Image(
                      width: 450,
                      height: 450,
                      image: AssetImage("assets/pokeballScroll.png"),
                    ),
                  ),
                  right: -230,
                ),
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(
                      () => updateListWithAngle(
                        details.localPosition - centerOfGestureDetector,
                        pokedexManager,
                      ),
                    );
                  },
                  onPanEnd: (details) => setState(
                    () => _oldAngle = _angle,
                  ),
                  onPanStart: (details) {
                    final touchPositionFromCenter = details.localPosition - centerOfGestureDetector;
                    _angleDelta = _oldAngle - touchPositionFromCenter.direction;
                  },
                  child: Container(color: Colors.transparent),
                ),
              ],
            );
          },
        ));
  }

  void updateListWithAngle(Offset touchPositionFromCenter, PokedexManager pokedexManager) {
    _angle = touchPositionFromCenter.direction + _angleDelta;

    index = _angle.toInt() * -1;

    if (index > pokedexManager.pokedex.simplePokemonResponse.length) {
      index = pokedexManager.pokedex.simplePokemonResponse.length;
    }

    _controller.animateToItem(
      index,
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Column buildBigButtonsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: greenButton,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: brownBorder,
                  width: 4,
                ),
              ),
              padding: const EdgeInsets.only(right: 40),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "CHERCHER POKéMON",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: blueButton,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: brownBorder,
                width: 4,
              ),
            ),
            padding: const EdgeInsets.only(right: 50),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "AUTRE POKéDEX",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: greenButton,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: brownBorder,
                  width: 4,
                ),
              ),
              padding: const EdgeInsets.only(right: 30),
              child: TextButton(
                onPressed: () {
                  /// Utilisation de MaterialPageRoute permettant de ne pas passer
                  /// par les routes standards
                  ///
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder(
                        future: pokedexManager.currentPokemon.getPokemonDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            pokedexManager.currentPokemon.pokemonDetails = snapshot.data! as DetailedPokemon;
                            return const PokemonDetailPage();
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  "CONSULTER POKéDEX",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildPokemonsListAndImage() {
    return Container(
      color: const Color.fromARGB(255, 75, 111, 149),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    const SizedBox(
                      width: 120,
                      height: 120,
                      child: Image(
                        image: AssetImage("assets/emptyCase.png"),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Image(
                        image: NetworkImage(
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" +
                              pokedexManager.currentPokemon.id +
                              ".png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 250,
            width: 200,
            child: ListWheelScrollView(
              controller: _controller,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (value) {
                pokedexManager.index = value;

                pokedexManager.setCurrentPokemon(
                  pokedexManager.pokedex.simplePokemonResponse.elementAt(value),
                );
                if ((value + 1) == pokedexManager.pokedex.simplePokemonResponse.length) {
                  DebugLogger.debugLog("home_page.dart", "onSelectedItemChanged", "⚠️ Load next page", 2);
                  pokedexManager.addNextPokedexPage(pokedexManager.pokedex.nextPagination!);
                }
              },
              diameterRatio: 2,
              itemExtent: 50,
              children: List.generate(
                pokedexManager.pokedex.simplePokemonResponse.length,
                (index) => PokemonRow(
                  pokedexManager: pokedexManager,
                  index: index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Consutrction de la colonne contenant les deux boutons de navigation du pokédex (haut et bas)
  Column buildPokedexNavigationButtonsColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => setState(() => _controller.jumpToItem(index--)),
          child: Container(
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 160, 178, 240),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                width: 3,
                color: brownBorder,
              ),
            ),
            child: const RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.skip_next,
                color: Color.fromARGB(255, 110, 140, 230),
                size: 25,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => setState(() => _controller.jumpToItem(index++)),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 160, 178, 240),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                width: 3,
                color: brownBorder,
              ),
            ),
            child: const RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.skip_next,
                color: Color.fromARGB(255, 110, 140, 230),
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Construction de la barre orange du haut du pokédex
  Align buildTopOverlay(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Image(
        image: const AssetImage("assets/topOverlay.png"),
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
