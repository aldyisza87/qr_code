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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    _searchController.text = " ";
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResult = [];
    if (_searchController.text.isNotEmpty) {
      for (var productSnapShot in _allResults) {
        var name = productSnapShot['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResult.add(productSnapShot);
        }
      }
    } else {
      const Center(child: Text('search'));
    }
    setState(() {
      _resultList = List.from(showResult);
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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
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
      backgroundColor: const Color(0xFF363062),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D4C7D),
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          controller: _searchController,
        ),
      ),
      body: ListView.builder(
        itemCount: _resultList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _resultList[index]['name'],
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            leading: Text(
              _resultList[index]['code'],
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            trailing: Text(
              _resultList[index]['address'],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
