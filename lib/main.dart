import 'package:pokedex/screen/pokemon_detail_page.dart';
import 'package:pokedex/model/pokedex_response.dart';
import 'package:pokedex/screen/home_page.dart';
import 'package:pokedex/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/global.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// Bloque l'orientation de l'écran.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /// FutureBuild permet de retourner la page d'accueil que lorsque les données ont été récupérées
    /// via l'appel apiManager.fetchAllData.
    /// Dans le cas échéant un indicateur de chargement est affiché.
    return MaterialApp(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<PokedexResponse>(
        future: apiManager.fetchAllData(pokedexApiAddress),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pokedexManager.initializePokedex(snapshot.data!);
            return const HomePage();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
