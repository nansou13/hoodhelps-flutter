import 'dart:convert';

import 'package:hoodhelps/Containers/widgets/add_job_widget.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditUserJobsPage extends StatefulWidget {
  const EditUserJobsPage({Key? key}) : super(key: key);

  @override
  _EditUserJobsPageState createState() => _EditUserJobsPageState();
}

class _EditUserJobsPageState extends State<EditUserJobsPage> {
  List<dynamic> userJob = [];
  bool isLoading = true;
  bool isMiniLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('user_token');

      if (userToken == null) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
      //recupere les jobs du users
      final responseJob = await http.get(
        Uri.parse('$routeAPI/api/users/me/job'),
        headers: {'Authorization': 'Bearer $userToken'},
      );
      if (responseJob.statusCode == 200) {
        final userJobData = jsonDecode(responseJob.body);

        setState(() {
          userJob = userJobData;
          isLoading = false;
        });
        return;
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, "Erreur: ${e.toString()}");
    }
  }

  Future<void> updateJob(jobID, description, experience_years) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    try {
      final response =
          await http.put(Uri.parse('$routeAPI/api/users/me/job/$jobID'), body: {
        'description': description,
        'experience_years': experience_years.toString(),
      }, headers: {
        'Authorization': 'Bearer $userToken'
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        // Créer une nouvelle liste de jobs avec la mise à jour
        List<dynamic> newUserJobs = userJob
            .map((job) => job['id'] == jobID
                ? {
                    ...job,
                    'description': description,
                    'experience_years': experience_years
                  }
                : job)
            .toList();

        // Mettre à jour userInfo avec la nouvelle liste de jobs
        setState(() {
          userJob = newUserJobs;
        });

        NotificationService.showInfo(context, 'Mis à jour avec succès');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, 'Échec de la mise à jour $data');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, 'Erreur: $e');
    }
    setState(() {
      isMiniLoading = false;
    });
  }

  Future<void> deleteJob(jobID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    try {
      final response =
          await http.delete(Uri.parse('$routeAPI/api/users/me/job/$jobID'), 
          headers: {
        'Authorization': 'Bearer $userToken'
      });
      
      if (response.statusCode == 204) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
       
        NotificationService.showInfo(context, 'Suppression effectuée avec succès');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, 'Échec de la suppression');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, 'Erreur: $e');
    }
    setState(() {
      isMiniLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      final translationService = context.read<TranslationService>();
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical, // Défilement vertical
              shrinkWrap: true, // Prendre la taille des éléments
              physics:
                  const NeverScrollableScrollPhysics(), // Puisqu'il est dans un ListView déjà déroulable.
              itemCount: userJob.length,
              itemBuilder: (context, index) {
                final job = userJob[index];
                final jobName = job['name'] ?? '';
                String experienceYears =
                    job['experience_years']?.toString() ?? '';

                return Dismissible(
                  key: Key(job['id'].toString()), // Assurez-vous que c'est unique
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Appelez votre fonction de suppression ici
                    //print(job['id']);
                    deleteJob(job['id']);
                    setState(() {
                      userJob.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  child: 
                Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(children: [
                              Icon(
                                IconsExtension.getIconData(jobName),
                                size: 25,
                              ), // Icône de travail
                              const SizedBox(width: 10.0),
                              Text(translationService.translate(jobName),
                                  style: const TextStyle(fontSize: 18)),
                            ]),
                            Padding(
                                padding: const EdgeInsets.only(left: 34.0),
                                child: Text(
                                  'Expérience : ' + experienceYears + ' years',
                                  style: const TextStyle(fontSize: 12),
                                )), // Affichage des années d'expérience
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(job,
                                index); // Passer les informations nécessaires en paramètre
                          },
                        ),
                      ],
                    ),
                  ),
                )
                );
              },
            ),
          ),
          _joinJobCard(),
        ],
      );
    }
  }

  void _showEditDialog(Map job, index) {
    final translationService = context.read<TranslationService>();
    // Définir la variable de valeur initiale du slider
    double _currentSliderValue = job['experience_years'] >= 10
        ? 10.0
        : double.parse(job['experience_years'].toString());
    TextEditingController jobNameController =
        TextEditingController(text: translationService.translate(job['name']));
    TextEditingController descriptionController =
        TextEditingController(text: job['description']);

    // Afficher le dialogue avec StatefulBuilder
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Modifier Job"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    enabled: false,
                    controller: jobNameController,
                    decoration: const InputDecoration(labelText: "Nom du job"),
                  ),
                  Row(children: <Widget>[
                    Text(
                        'Expérience: ${_currentSliderValue >= 10 ? '10+' : _currentSliderValue.toInt().toString()} ans'),
                    Expanded(
                      child: Slider(
                        value: _currentSliderValue,
                        min: 0,
                        max: 10, // La valeur maximale
                        divisions: 10, // Le nombre de divisions
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            // Ce setState est celui fourni par StatefulBuilder
                            _currentSliderValue = value;
                          });
                        },
                      ),
                    ),
                  ]),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  child: const Text("Annuler"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme la boîte de dialogue
                  },
                ),
                MaterialButton(
                  child: const Text("Valider"),
                  onPressed: () async {
                    await updateJob(job['id'], descriptionController.text,
                        _currentSliderValue.round());
                    Navigator.of(context).pop(); // Ferme la boîte de dialogue
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Ce code s'exécute après la fermeture du dialogue
      // Vous pourriez mettre à jour l'état global de votre application ici si nécessaire
    });
  }

  void _saveJobCallback(data) {
     Navigator.of(context).pop(); // Ferme la boîte de dialogue
    loadData();
  }

  void _showAddJob() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Ajouter un Job"),
              content: AddJobWidget(saveJobCallback: _saveJobCallback,),
              
              actions: <Widget>[
                MaterialButton(
                  child: const Text("Annuler"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme la boîte de dialogue
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Ce code s'exécute après la fermeture du dialogue
      // Vous pourriez mettre à jour l'état global de votre application ici si nécessaire
    });
  }

  Widget _joinJobCard() {
  return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: _showAddJob,
            child: const Row(children: [
              Icon(
                Icons.add,
                size: 25.0,
              ), // Icône de travail
              SizedBox(width: 10.0),
              Text(
                "Ajouter un métier",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
        ),
      ));
}

}

