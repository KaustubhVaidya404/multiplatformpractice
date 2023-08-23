

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "MultiPlatform",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}


class MyAppState extends ChangeNotifier{
  var current = WordPair.random();
  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }
  var fav = <WordPair>[];
  void togggleFav(){
    if(fav.contains(current)){
      fav.remove(current);
    }
    else{
      fav.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex){
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(child: NavigationRail(destinations: [NavigationRailDestination(icon: Icon(Icons.home), label: Text("Home")), NavigationRailDestination(icon: Icon(Icons.favorite), label: Text("Fav"))], selectedIndex: selectedIndex, onDestinationSelected: (value){
                setState(() {
                  selectedIndex = value;
                });
              })),
              Expanded(child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: GeneratorPage(),
              ))
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<MyAppState>();
    var pair = appstate.current;
    IconData icon;
    if(appstate.fav.contains(pair)){
      icon = Icons.favorite;
    }
    else{
      icon = Icons.favorite_border;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigCard(pair: pair),
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () => appstate.togggleFav(), child: Icon(icon)),
            SizedBox(width: 10),
            ElevatedButton(onPressed: () => appstate.getNext(), child: Text("Next"))
          ],
        )
      ],
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary
    );
    return Card(
      elevation: 0.00,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
            pair.asLowerCase,
            style: style,
            semanticsLabel: "${pair.first} ${pair.second}",),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if(appState.fav.isEmpty){
      return Center(
        child: Text("No favorites found yet"),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('You have ${appState.fav.length} favorites: '),
        ),
        for (var pair in appState.fav)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          )
      ],
    );
  }
}

