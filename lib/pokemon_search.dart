import 'dart:async';
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
  List<Map<String, PokemonChip>> _allChips = [];
  List<Map<String, PokemonChip>> _chipsToShow = [];
  String _searchText = "";
  Random _random = Random();
  Timer? _debounceTimer;

  @override
  void initState() {
    Uri uri = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1500');
    get(uri)
        .then((res) => json.decode(res.body))
        .then((res) => res["results"])
        .then((pokemons) => setState(() {
              _allChips = _makeChips(pokemons);
              _chipsToShow = _allChips;
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
          Text("${_chipsToShow.length} pokemon found"),
          TextField(onChanged: (val) {
            if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
            _debounceTimer = Timer(const Duration(milliseconds: 500), () {
              _searchText = val;
              RegExp re = RegExp(_searchText);
              setState(() => _chipsToShow = _allChips
                  .where((chip) => re.hasMatch(chip.keys.toList()[0]))
                  .toList());
            });
          }),
          SizedBox(
            height: 700.0,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: _chipsToShow
                    .map((chip) => chip.values.toList()[0])
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, PokemonChip>> _makeChips(List pokemons) {
    return pokemons
        .map<Map<String, PokemonChip>>(
            (p) => {p["name"]: PokemonChip(name: p["name"], url: p["url"])})
        .toList();
  }
}

class PokemonChip extends StatelessWidget {
  const PokemonChip({
    super.key,
    required this.name,
    required this.url,
  });
  final String name;
  final String url;

  @override
  Widget build(BuildContext context) {
    print("Built a chip");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        child: Text(
          name,
          style: const TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          print("You clicked $name $url");
        },
      ),
    );
  }
}
