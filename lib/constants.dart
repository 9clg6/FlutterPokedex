import 'package:flutter/material.dart';

/// Fichie de constants permettant d'éviter la redondance de code

const pokedexApiAddress = 'https://pokeapi.co/api/v2/pokemon/';
const maxNumberOfPokemon = 20;

var greenButton = const Color.fromARGB(255, 150, 214, 111);
var blueButton = const Color.fromARGB(255, 120, 213, 207);
var brownBorder = const Color.fromARGB(255, 115, 102, 79);
var littleButtonBorderColor = const Color.fromARGB(255, 72, 94, 56);
var littleButtonBackgroundColor = const Color.fromARGB(255, 144, 167, 246);

double littleButtonWidth = 55;
double littleButtonHeight = 40;

double borderWidth = 15;
double borderWeight = 5;

final buttonTextList = [
  "INFO", "ZONE", "CRI", "TAILLE", "FORME"
];