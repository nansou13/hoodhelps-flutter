import 'dart:convert';

import 'package:hoodhelps/Containers/Widgets/add_job_widget.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:flutter/material.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';

class EditUserJobsPage extends StatefulWidget {
  const EditUserJobsPage({super.key});

  @override
  EditUserJobsPageState createState() => EditUserJobsPageState();
}

class EditUserJobsPageState extends State<EditUserJobsPage> {
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
      final userToken = await ApiService().getToken();

      if (userToken == null) {
        Navigator.of(navigatorKey.currentContext!)
            .pushReplacementNamed(RouteConstants.registerLogin);
        return;
      }
      //recupere les jobs du users
      final responseJob = await ApiService().get(
        '/users/me/job',
        useToken: true,
      );
      if (responseJob.statusCode == 200) {
        final userJobData = jsonDecode(responseJob.body);

        setState(() {
          userJob = userJobData;
          isLoading = false;
        });
        return;
      } else {
        Navigator.of(navigatorKey.currentContext!)
            .pushReplacementNamed(RouteConstants.registerLogin);
        return;
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError( "Erreur: ${e.toString()}");
    }
  }

  Future<void> updateJob(jobID, description, experienceYears) async {
    try {
      final response =
          await ApiService().put('/users/me/job/$jobID', useToken: true, body: {
        'description': description,
        'experience_years': experienceYears.toString(),
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
                    'experience_years': experienceYears
                  }
                : job)
            .toList();

        // Mettre à jour userInfo avec la nouvelle liste de jobs
        setState(() {
          userJob = newUserJobs;
        });

        NotificationService.showInfo( 'Mis à jour avec succès');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError( 'Échec de la mise à jour $data');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError( 'Erreur: $e');
    }
    setState(() {
      isMiniLoading = false;
    });
  }

  Future<void> deleteJob(jobID) async {
    try {
      final response = await ApiService()
          .delete('/users/me/job/$jobID', useToken: true, context: context);
      if (response.statusCode == 204) {
        // Si la requête réussit (statut 200), analyser la réponse JSON

        NotificationService.showInfo('Suppression effectuée avec succès');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError('Échec de la suppression');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError( 'Erreur: $e');
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
      return Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
              child: SingleChildScrollView(
            // Utilisez SingleChildScrollView pour rendre le contenu défilable
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Column(
                children: [
                  // ...Liste des travaux...
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap:
                        true, // Important pour ListView.builder dans une colonne
                    physics:
                        const NeverScrollableScrollPhysics(), // Pour que ListView n'intercepte pas le défilement
                    itemCount: userJob.length,
                    itemBuilder: (context, index) {
                      final job = userJob[index];
                      final jobName = job['name'] ?? '';
                      String experienceYears =
                          job['experience_years']?.toString() ?? '';

                      return Dismissible(
                          key: Key(job['id']
                              .toString()), // Assurez-vous que c'est unique
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            // Appelez votre fonction de suppression ici
                            deleteJob(job['id']);
                            setState(() {
                              userJob.removeAt(index);
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                          ),
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(children: [
                                        Icon(
                                          IconsExtension.getIconData(jobName),
                                          size: 25,
                                        ), // Icône de travail
                                        const SizedBox(width: 10.0),
                                        Text(
                                            translationService
                                                .translate(jobName),
                                            style:
                                                const TextStyle(fontSize: 18)),
                                      ]),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 34.0),
                                          child: Text(
                                            '${translationService.translate("EXPERIENCE")} : $experienceYears ${translationService.translate("YEARS")}',
                                            style:
                                                const TextStyle(fontSize: 12),
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
                          ));
                    },
                  ),
                ],
              ),
            ),
          )),
          _joinJobCard(),
        ],
      ));
    }
  }

  void _showEditDialog(Map job, index) {
    final translationService = context.read<TranslationService>();
    // Définir la variable de valeur initiale du slider
    double currentSliderValue = job['experience_years'] >= 10
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
              title: Text(translationService.translate("EDIT_JOB")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    enabled: false,
                    controller: jobNameController,
                    decoration: InputDecoration(
                        labelText:
                            translationService.translate("HINT_TEXT_JOB")),
                  ),
                  Row(children: <Widget>[
                    Text(
                        '${translationService.translate("EXPERIENCE")}: ${currentSliderValue >= 10 ? '10+' : currentSliderValue.toInt().toString()} ${translationService.translate("YEARS")}'),
                    Expanded(
                      child: Slider(
                        value: currentSliderValue,
                        min: 0,
                        max: 10, // La valeur maximale
                        divisions: 10, // Le nombre de divisions
                        label: currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            // Ce setState est celui fourni par StatefulBuilder
                            currentSliderValue = value;
                          });
                        },
                      ),
                    ),
                  ]),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        labelText: translationService.translate("DESCRIPTION")),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text(translationService.translate("CANCEL")),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme la boîte de dialogue
                  },
                ),
                MaterialButton(
                  child: Text(translationService.translate("SAVE")),
                  onPressed: () async {
                    await updateJob(job['id'], descriptionController.text,
                        currentSliderValue.round());
                    Navigator.of(navigatorKey.currentContext!).pop(); // Ferme la boîte de dialogue
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
    final translationService = context.read<TranslationService>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(translationService.translate("ADD_JOB")),
              content: AddJobWidget(
                saveJobCallback: _saveJobCallback,
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text(translationService.translate("CANCEL")),
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
    final translationService = context.read<TranslationService>();
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _showAddJob,
              child: Row(children: [
                const Icon(
                  Icons.add,
                  size: 25.0,
                ), // Icône de travail
                const SizedBox(width: 10.0),
                Text(
                  translationService.translate('ADD_JOB'),
                  style: const TextStyle(
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
