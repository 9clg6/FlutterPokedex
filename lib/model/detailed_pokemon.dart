/// Detail d'un pokémon
class DetailedPokemon {
  String id;
  String name;
  List<String> listTypes = [];
  int weight = 0;
  int height = 0;

  DetailedPokemon({
    required this.id,
    required this.name,
    required this.listTypes,
    required this.weight,
    required this.height,
  });

  /// Factory permettant de construit un DetailedPokemon à partir d'une map
  factory DetailedPokemon.fromJson(Map<String, dynamic> json, String id) {
    List<String> tempListTypes = [];

    for (final obj in json['types'] as List) {
      tempListTypes.add(obj['type']['name']);
    }

    return DetailedPokemon(
      id: id,
      name: json['name'],
      listTypes: tempListTypes,
      weight: json['weight'],
      height: json['height'],
    );
  }
}
