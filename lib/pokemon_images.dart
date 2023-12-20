import 'package:flutter/material.dart';
import 'package:flutter_pokedex/types/pokemon.dart';

class PokemonImages extends StatelessWidget {
  final Sprites sprites;

  const PokemonImages({required this.sprites, super.key});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      sprites.frontDefault,
      sprites.backDefault,
      sprites.frontFemale,
      sprites.backFemale,
      sprites.frontShiny,
      sprites.backShiny,
      sprites.frontShinyFemale,
      sprites.backShinyFemale
    ]
        .where((sprite) => sprite != null)
        .map((sprite) => sprite.toString())
        .toList();

    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: images
            .map((sprite) => Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Image.network(
                  sprite,
                  height: 200,
                  fit: BoxFit.contain,
                )))
            .toList(),
      ),
    );
  }
}
