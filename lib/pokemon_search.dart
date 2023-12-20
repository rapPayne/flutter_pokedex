import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({super.key});

  @override
  State<PokemonSearch> createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  List<dynamic> _allPokemons = [];
  List<dynamic> _pokemonsToShow = [];
  String _searchText = "";
  Random _random = Random();

  @override
  void initState() {
    Uri uri = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1500');
    get(uri)
        .then((res) => json.decode(res.body))
        .then((res) => res["results"])
        .then((pokemons) => setState(() {
              _allPokemons = pokemons;
              _pokemonsToShow = _allPokemons;
            }))
        .then((foo) => print("Fetched ${_random.nextInt(1000)}"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Built ${_random.nextInt(1000)}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokemon Lookup"),
      ),
      body: Column(
        children: [
          Text(_searchText),
          TextField(
            onChanged: (val) {
              _searchText = val;
              RegExp re = RegExp(_searchText);
              setState(() => _pokemonsToShow = _allPokemons
                  .where((element) => re.hasMatch(element["name"]))
                  .toList());
            },
          ),
          SizedBox(
            height: 700.0,
            child: SingleChildScrollView(
              child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: _makeChips(_pokemonsToShow)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _makeChips(List pokemons) {
    return pokemons
        .map((p) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Text(
                  p["name"],
                  style: const TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  print("You clicked ${p['name']} ${p['url']}");
                },
              ),
            ))
        .toList();
  }
}
