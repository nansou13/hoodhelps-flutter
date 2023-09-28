import 'package:flutter/material.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../constants.dart';

class Step3Widget extends StatefulWidget {
  final Function nextStepCallback;

  const Step3Widget({Key? key, required this.nextStepCallback})
      : super(key: key);

  @override
  _Step3WidgetState createState() => _Step3WidgetState();
}

class _Step3WidgetState extends State<Step3Widget> {
  
  String? selectedCategoryId;
  Job? selectedJob;
  String? selectedJobId;

  List<Category> categories = [];
  List<Job> jobs = [];
  bool isJobTextFieldEnabled =
      false; // Nouvelle variable pour gérer l'état d'activation du champ de texte des emplois

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final response = await http.get(Uri.parse('$routeAPI/api/categories/'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['categories'];
      setState(() {
        categories =
            jsonData.map((category) => Category.fromJson(category)).toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> loadJobsForCategory(String categoryId) async {

    final response =
        await http.get(Uri.parse('$routeAPI/api/categories/$categoryId'));
    if (response.statusCode == 200) {
      final resultJson = json.decode(response.body);
      final List<dynamic> jsonData = resultJson;
      setState(() {
        jobs = jsonData.map((job) => Job.fromJson(job)).toList();
      });
    } else {
      throw Exception('Failed to load jobs for category');
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          onTap: () {
            _showCategoryPicker(context);
          },
          readOnly: true,
          decoration: const InputDecoration(
            hintText: 'Sélectionnez une catégorie',
          ),
          controller: TextEditingController(
            text: translationService.translate(categories
                .firstWhere(
                  (category) => category.id == selectedCategoryId,
                  orElse: () => Category(id: '', name: ''),
                )
                .name),
          ),
        ),
        const SizedBox(height: 16), // Ajoute un espacement
        TextField(
          onTap: () {
            // Utilisez onTap pour ouvrir la liste des emplois lorsqu'il est cliqué
            if (isJobTextFieldEnabled) {
              _showJobPicker(context);
            }
          },
          readOnly: true,
          enabled: isJobTextFieldEnabled,
          decoration: const InputDecoration(
            hintText: 'Sélectionnez un emploi',
          ),
          controller: TextEditingController(
            text: translationService.translate(jobs
                .firstWhere(
                  (job) => job.id == selectedJobId,
                  orElse: () => Job(id: '', name: ''),
                )
                .name),
          ),
        ),
      ],
    );
  }

  Future<void> _showCategoryPicker(BuildContext context) async {
    final translationService = context.read<TranslationService>();
    final selectedCategory = await showModalBottomSheet<Category>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(translationService.translate(categories[index].name)),
                      onTap: () async {
                        Navigator.of(context).pop(categories[index]);
                        await loadJobsForCategory(categories[index].id);
                        setState(() {
                          isJobTextFieldEnabled = true;
                        });
                      },
                    );
                  },
                ),
              ),
            
            ],
          ),
        );
      },
    );

    if (selectedCategory != null) {
      setState(() {
        selectedCategoryId = selectedCategory.id;
        jobs.clear();
        isJobTextFieldEnabled = false;
      });
    }
  }

  Future<void> _showJobPicker(BuildContext context) async {
    final translationService = context.read<TranslationService>();
    final selectedJob = await showModalBottomSheet<Job>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(translationService.translate(jobs[index].name)),
                      onTap: () {
                        Navigator.of(context)
                            .pop(jobs[index]); // Sélection de l'emploi
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedJob != null) {
      setState(() {
        selectedJobId =
            selectedJob.id; // Mettez à jour l'ID de l'emploi sélectionné
      });
    }
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}

class Job {
  final String id;
  final String name;

  Job({required this.id, required this.name});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(id: json['id'], name: json['name']);
  }
}
