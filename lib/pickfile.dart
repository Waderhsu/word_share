import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'definition.dart';
import 'search.dart';

class WordList extends StatefulWidget {
  @override
  WordListState createState() => WordListState();
}

class WordListState extends State<WordList> {

  List<List<dynamic>> data = [];

  // This function is triggered when the floating button is pressed
  void loadCSV() async {
    final rawData = await rootBundle.loadString("assets/word1200.csv");
    List<List<dynamic>> listData = CsvToListConverter().convert(rawData);
    setState(() {
      data = listData;
    });
  }


  List<List<String>> EnglishData(List<List<dynamic>> Data) {
    List<List<String>> english = [[],[]];
    for (int i = 0; i < Data.length - 1; i = i + 1){
      english[0].add(i.toString());
      english[1].add(Data[i + 1][1]);
    }
    return english;
  }

  void indexcount() {
    setState(() {
      INDEX = INDEX + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadCSV());
    return Scaffold(
      appBar: AppBar(
        title: Text('Word'),
        actions: [
          IconButton(
              onPressed: (){
                showSearch(
                    context: context,
                    delegate: Search(EnglishData(data),EnglishData(data), data));
              },
              icon: Icon(Icons.search),
          )
        ],
      ),
      body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return Card(
                margin: const EdgeInsets.all(3),
                color: index == 0 ? Colors.amber : Colors.white,
                child: ListTile(
                  leading: ElevatedButton(
                    child: Text(data[index][0].toString()),
                    onPressed:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Definition(index, data)),
                      );
                    },
                  ),
                  //Text(_data[index][0].toString()),
                  title: Text(data[index][1]),
                  trailing: Text(data[index][2].toString()),
                ),
              );
            },
          ),
          // floatingActionButton:
          // FloatingActionButton(child: Icon(Icons.add), onPressed: _loadCSV),
      );
  }
}