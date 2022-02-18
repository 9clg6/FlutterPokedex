# Flutter Pokedex
**Flutter Pokedex** est un projet projet développé par **Clément GUYON** dans le cadre du module "Développement Mobile" à l'école **Ynov Lyon Campus** 🎓. 

L'objectif que je m'étais fixé était de créer une interface quasi-conforme au Pokedex de Pokémon version Diamant & Perle sortie le 28 Septembre 2006 :
 
![Pokémon Diamant et Perle &gt; Nouveau pokédex - Pokébip.com](https://www.pokebip.com/pages/jeuxvideo/dp/images/nouveau-pokedex.png)

## Données

La liste des Pokémons ainsi que leurs détails ont été récupérés depuis l'API [PokéApi](https://pokeapi.co/) disponible gratuitement.

Afin d'afficher les données de manière **optimisée**, une première liste de **20 Pokémons** est récupérée, ainsi que l'URL d'appel pour les 20 suivants.
Lorsque l'élement affiché correspond au dernier élement de la liste, l'application appelle l'API afin d'afficher les 20 éléments suivants.

Les détails d'un Pokémons ne sont affichés que lorsqu'on sélectionne ce dernier, afin de ne pas appeler l'API de manière inutile et de ne pas charger des données dont nous n'avons pas besoin dans l'immédiat.

![](https://www.pokebip.com/pages/jeuxvideo/dp/images/nouveau-pokedex2.png)

## Résultat

 - [x] Utilisation d'une WheelList 
 - [x] Rotation de l'image de la Pokeball qui permet de bouger la liste du dessus. 
 - [x] Affichage dynamique des images des Pokémons

![Interface principale de l'application](https://media.discordapp.net/attachments/786644865437270038/943836181873963039/unknown.png)

 - [x] Curseur de sélection sur une liste de boutons générée depuis une liste de texte.
 - [x] Affichage dynamique des types des pokémons sous forme d'image.

![Interface de détails d'un Pokémon](https://media.discordapp.net/attachments/786644865437270038/943836220788727858/unknown.png)


