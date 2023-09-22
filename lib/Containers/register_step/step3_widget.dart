import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Pour la manipulation JSON
import 'package:http/http.dart' as http; // Pour les requêtes HTTP

class Step3Widget extends StatefulWidget {
  final Function nextStepCallback; // Ajoutez ce paramètre

  const Step3Widget({Key? key, required this.nextStepCallback}) : super(key: key);

  @override
  _Step3WidgetState createState() => _Step3WidgetState();
}

class _Step3WidgetState extends State<Step3Widget> {
  String selectedCategoryName = '';
  String selectedCategoryId = '';
  String _errorMessage = ''; // Message d'erreur local

  List<Category> categories = []; // Liste pour stocker les catégories

  @override
  void initState() {
    super.initState();
    // Chargez les catégories depuis votre API ici (par exemple, dans une fonction async)
    loadCategories();
  }

  Future<void> loadCategories() async {
    final response = await http.get(Uri.parse('http://localhost:5100/api/categories/'));
    if (response.statusCode == 200) {
      final List<dynamic> categoryData = json.decode(response.body)['categories'];
      final List<Category> loadedCategories = categoryData
          .map((category) => Category(id: category['id'], name: category['name']))
          .toList();
      setState(() {
        categories = loadedCategories;
      });
    } else {
      setState(() {
          _errorMessage = 'Error...';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _errorMessage, // Utilisation de errorMessage
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
  onTap: () {
    // Ouvrez le CupertinoPicker lorsque le TextField est cliqué
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                selectedCategoryId = categories[index].id;
                selectedCategoryName = categories[index].name;
              });
            },
            children: categories.map((Category category) {
              return Text(category.name);
            }).toList(),
          ),
        );
      },
    );
  },
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      selectedCategoryName.isNotEmpty ? selectedCategoryName : 'Sélectionnez une catégorie',
      style: TextStyle(fontSize: 18),
    ),
  ),
),

            Text(
              'ID de catégorie sélectionnée : $selectedCategoryId',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
}
