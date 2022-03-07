import 'package:pokedex/model/pokedex_response.dart';
import 'package:pokedex/screen/home_page.dart';
import 'package:pokedex/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/global.dart';
import 'package:pokedex/screen/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.wait([
          apiManager.fetchAllData(pokedexApiAddress),
          SharedPreferences.getInstance(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            pokedexManager.initializePokedex(snapshot.data![0]);

            bool? isFirstStart = snapshot.data![1].getBool('repeat');

            if (isFirstStart == false) return const HomePage();
            return const RegisterPage();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      routes: {
        "/register": (context) => const RegisterPage(),
        "/home": (context) => const HomePage(),
      },
    );
  }
}
