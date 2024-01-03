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
  Map<String, PokemonChip> _allChips = {};
  Map<String, PokemonChip> _chipsToShow = {};
  String _searchText = "";
  final Random _random = Random();
  Timer? _debounceTimer;

  @override
  void initState() {
    Uri uri = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1500');
    get(uri)
        .then((res) => json.decode(res.body))
        .then((res) => res["results"] as List<dynamic>)
        .then((pokemons) => setState(() {
              var transformed = pokemons
                  .map((p) => p as Map)
                  .map((p) => p as Map<String, dynamic>)
                  .toList();
              _allChips = _makeChips(transformed);
              _chipsToShow = {..._allChips};
            }))
        .then((foo) => debugPrint("Fetched ${_random.nextInt(1000)}"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Built ${_random.nextInt(1000)}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokemon Lookup"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${_allChips.length} pokemon found"),
          Text("${_chipsToShow.length} pokemon found"),
          TextField(onChanged: (val) {
            if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
            _debounceTimer = Timer(const Duration(milliseconds: 500), () {
              _searchText = val;
              RegExp re = RegExp(_searchText);
              setState(() {
                _chipsToShow.clear();
                var matches = _allChips.entries
                    .where((p) => re.hasMatch(p.key))
                    .map((p) => MapEntry(p.key, p.value));
                _chipsToShow.addEntries(matches);
              });
            });
          }),
          Expanded(
            // 1. Performance is terrible due to each build method rerendering
            // child: SingleChildScrollView(
            //   child: Wrap(
            //       alignment: WrapAlignment.spaceBetween,
            //       children: _chipsToShow.values.toList()),
            // ),
            // 2. Performance FTW! But lots of scrolling.
            // child: ListView(
            //   children: _chipsToShow.values.toList(),
            // ),
            // 3. Now less scrolling but still too much space between rows
            child: GridView.extent(
              maxCrossAxisExtent: 200.0,
              children: _chipsToShow.values.toList(),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, PokemonChip> _makeChips(List<Map<String, dynamic>> pokemons) {
    Map<String, PokemonChip> chips = {};
    for (var p in pokemons) {
      chips[p["name"]] =
          PokemonChip(name: p["name"], url: p["url"], key: ValueKey(p["name"]));
    }
    return chips;
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
    debugPrint("Built a chip");
    return Offstage(
      offstage: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          child: Text(
            name,
            style: const TextStyle(fontSize: 20.0),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/pokemon-details',
                arguments: {"url": url});
          },
        ),
      ),
    );
  }
}
