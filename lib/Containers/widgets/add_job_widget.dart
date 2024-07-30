import 'package:flutter/material.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class AddJobWidget extends StatefulWidget {
  final Function saveJobCallback;

  const AddJobWidget({Key? key, required this.saveJobCallback})
      : super(key: key);

  @override
  _AddJobWidgetState createState() => _AddJobWidgetState();
}

class _AddJobWidgetState extends State<AddJobWidget> {
  String? selectedCategoryId;
  Job? selectedJob;
  String? selectedJobId;
  String description = ""; // Champ de description
  int experienceYears = 0; // Valeur initiale du curseur

  List<Category> categories = [];
  List<Job> jobs = [];
  bool isJobTextFieldEnabled =
      false; // Nouvelle variable pour gérer l'état d'activation du champ de texte des emplois
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final response = await http.get(Uri.parse('$routeAPI/api/categories/'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        categories =
            jsonData.map((category) => Category.fromJson(category)).toList();
      });
      isLoading = false;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> loadJobsForCategory(String categoryId) async {
    final response =
        await http.get(Uri.parse('$routeAPI/api/categories/$categoryId'));
    if (response.statusCode == 200) {
      final resultJson = json.decode(response.body);
      final List<dynamic> jsonData = resultJson['professions_list'];
      setState(() {
        jobs = jsonData.map((job) => Job.fromJson(job)).toList();
      });
    } else {
      throw Exception('Failed to load jobs for category');
    }
  }

  Future<void> saveUserJobData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    try {
      final response =
          await http.post(Uri.parse('$routeAPI/api/users/me/job'), body: {
        "profession_id": selectedJobId,
        "description": description,
        "experience_years": experienceYears.toString(),
      }, headers: {
        'Authorization': 'Bearer $userToken'
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        widget.saveJobCallback({
          'profession_id': selectedJobId,
          'description': description,
          'experience_years': experienceYears.toString(),
        });
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, "Échec ajout du job $data");
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, "Erreur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return SingleChildScrollView(
      // Ajoutez le SingleChildScrollView ici
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            enabled: !isLoading,
            onTap: () {
              _showCategoryPicker(context);
            },
            readOnly: true,
            decoration: InputDecoration(
              hintText: translationService.translate('HINT_TEXT_SELECT_CATEGORY'),
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
          const SizedBox(height: 20), // Ajoute un espacement
          TextField(
            onTap: () {
              // Utilisez onTap pour ouvrir la liste des emplois lorsqu'il est cliqué
              if (isJobTextFieldEnabled) {
                _showJobPicker(context);
              }
            },
            readOnly: true,
            enabled: isJobTextFieldEnabled,
            decoration: InputDecoration(
              hintText: translationService.translate('HINT_TEXT_SELECT_JOB'),
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
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) {
              setState(() {
                description = value; // Mettre à jour la description
              });
            },
            decoration: InputDecoration(
              hintText: translationService.translate('HINT_TEXT_ADD_DESCRIPTION'),
            ),
            enabled: selectedJobId != null,
          ),
          const SizedBox(height: 20),
          Row(children: <Widget>[
            Text(
                '${translationService.translate("EXPERIENCE")}: ${experienceYears == 10 ? '10+' : experienceYears.toString()} ${translationService.translate("YEARS")}'),
            Expanded(
              child: Slider(
                value: experienceYears.toDouble(),
                onChanged: (value) {
                  if (selectedJobId != null) {
                    setState(() {
                      experienceYears = value.toInt();
                    });
                  }
                },
                min: 0,
                max: 10,
                divisions: 10,
              ),
            ),
          ]),
          const SizedBox(height: 20.0),
          MaterialButton(
            onPressed: () {
              if (selectedJobId != null) {
                saveUserJobData();
              }
            },
            color: selectedJobId != null ? Color(0xFF102820) : Colors.grey,
            textColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: double.infinity,
              height: 50.0,
              alignment: Alignment.center,
              child: Text(
                translationService.translate('ADD_THIS_JOB'),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
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
                      title: Row(
                        children: [
                          Icon(IconsExtension.getIconData(categories[index]
                              .name)), // Affichez l'icône ici à gauche
                          const SizedBox(
                              width:
                                  10), // Ajoutez un espace entre l'icône et le texte
                          Expanded(
                            child: Text(
                              translationService
                                  .translate(categories[index].name),
                              softWrap:
                                  true, // Permet au texte de passer à la ligne si nécessaire
                            ),
                          ),
                        ],
                      ),
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
        selectedJobId = null;
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
                      title: Row(
                        children: [
                          Icon(IconsExtension.getIconData(jobs[index]
                              .name)), // Affichez l'icône ici à gauche
                          const SizedBox(
                              width:
                                  10), // Ajoutez un espace entre l'icône et le texte
                          Expanded(
                            child: Text(
                              translationService.translate(jobs[index].name),
                              softWrap:
                                  true, // Permet au texte de passer à la ligne si nécessaire
                            ),
                          ),
                        ],
                      ),
                      // title: Text(translationService.translate(jobs[index].name)),
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
