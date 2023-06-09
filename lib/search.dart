import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searcController = TextEditingController();

  @override
  void initState() {
    _searcController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResult = [];
    if (_searcController.text != "") {
      for (var productSnapShot in _allResults) {
        var name = productSnapShot['name'].toString().toLowerCase();
        if (name.contains(_searcController.text.toLowerCase())) {
          showResult.add(productSnapShot);
        }
      }
    } else {
      showResult = List.from(_allResults);
    }
    setState(() {
      _resultList = showResult;
    });
  }

  getStream() async {
    var data = await FirebaseFirestore.instance
        .collection('product')
        .orderBy('name')
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searcController.removeListener(_onSearchChanged);
    _searcController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          controller: _searcController,
        ),
      ),
      body: ListView.builder(
        itemCount: _resultList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _resultList[index]['code'],
            ),
            subtitle: Text(
              _resultList[index]['name'],
            ),
            trailing: Text(
              _resultList[index]['qty'].toString(),
            ),
          );
        },
      ),
    );
  }
}
