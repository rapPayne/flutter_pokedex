import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/extensions/string_extensions.dart';
import 'package:flutter_pokedex/pokemon_images.dart';
import 'package:http/http.dart';
import './types/pokemon.dart';

class Pokemon extends StatefulWidget {
  const Pokemon({super.key});

  @override
  State<Pokemon> createState() => _PokemonState();
}

class _PokemonState extends State<Pokemon> {
  PokeApiResponse? _pokemon;
  String url = '';

  @override
  void initState() {
    super.initState();
    // PostFrameCallback needed b/c ModalRoute.of() can't be read in initState. But we must make the get() in initState. This method registers a callback to run after initState is complete.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      Uri uri = Uri.parse(args["url"]);
      get(uri)
          .then((res) => json.decode(res.body))
          .then((json) => PokeApiResponse.fromJson(json))
          .then((PokeApiResponse res) => setState(() {
                _pokemon = res;
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    var sprites = _pokemon?.sprites;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(_pokemon?.name.toCapitalizeWords() ?? ""),
            sprites != null
                ? PokemonImages(
                    sprites: sprites,
                  )
                : const Text("Loading..."),
            const Text("Stats go here"),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: showStats(_pokemon?.stats),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Image.asset("pokemon_icon.png"),
        title:
            Text(_pokemon?.name.toCapitalizeWords() ?? "Loading, please wait"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget showStats(List<Stat>? stats) {
    if (stats == null) return Container();
    var textStyle = Theme.of(context).textTheme.titleLarge;
    return Table(
      children: [
        TableRow(children: [
          Text("Name", style: textStyle),
          Text("Base stat", style: textStyle),
          Text("Effort", style: textStyle),
        ]),
        ...stats.map((stat) => TableRow(children: [
              Text(stat.stat.name),
              Text(stat.baseStat.toString()),
              Text(stat.effort.toString())
            ]))
      ],
    );
  }
}
