// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/extensions/string_extensions.dart';
import 'package:http/http.dart';
import './types/pokemon.dart';

class Pokemon extends StatefulWidget {
  const Pokemon({super.key});

  @override
  State<Pokemon> createState() => _PokemonState();
}

class _PokemonState extends State<Pokemon> {
  PokeApiResponse? _pokemon;

  @override
  void initState() {
    Uri uri = Uri.parse('https://pokeapi.co/api/v2/pokemon/pikachu');
    get(uri)
        .then((res) => json.decode(res.body))
        .then((json) => PokeApiResponse.fromJson(json))
        .then((PokeApiResponse res) => setState(() {
              _pokemon = res;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("pokemon is ${(_pokemon?.name ?? 'Loading, please wait')}");
    return Scaffold(
      body: Column(
        children: [
          Text(_pokemon?.name.toCapitalizeWords() ?? ""),
        ],
      ),
      appBar: AppBar(
        leading: Image.asset("pokemon_icon.png"),
        title:
            Text(_pokemon?.name.toCapitalizeWords() ?? "Loading, please wait"),
      ),
    );
  }
}
