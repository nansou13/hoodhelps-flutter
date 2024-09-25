import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Modules/user_update/circle_avatar_update.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/job_badge_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/job_service.dart';
import 'package:hoodhelps/services/jobs_provider.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserAccountJobs extends StatefulWidget {
  const UserAccountJobs({Key? key}) : super(key: key);

  @override
  _UserAccountJobsState createState() => _UserAccountJobsState();
}

class _UserAccountJobsState extends State<UserAccountJobs> {
  bool isLoading = true;
  bool isMiniLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserService>(context, listen: false);
    final userJob = user.jobs;
    return Scaffold(
      backgroundColor: FigmaColors.lightLight4,
      appBar: genericAppBar(
          context: context, appTitle: 'Mes métiers'), // Background color
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [   
                ...userJob.map((job) => _buildGroupBlock(context, job)).toList(),
                SizedBox(height: 20),
                buildButton(
                  onPressed: () {
                    _showAddJobModal(context);
                  },
                  text: 'Ajouter un métier',
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildGroupBlock(BuildContext context, Job job) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: EdgeInsets.only(bottom: 12.0),
      alignment: Alignment.topLeft,
      width: double.infinity,
      decoration: BoxDecoration(
        color: FigmaColors.lightLight3,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: FigmaColors.lightLight2,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: JobBadge(job_id: job.id),
            ),
          ),
              
              IconButton(onPressed: () async {
                _showEditModal(context, job);
                // await deleteGroup(group.id);
              }, 
              icon: Icon(Icons.edit_note, color: FigmaColors.darkDark0, size: 20))
              
            ],
          ),
          Text(
              '${job.experience_years} année${job.experience_years > 1 ? 's' : ''} d\'expérience',
              style: FigmaTextStyles().body14pt.copyWith(color: FigmaColors.darkDark2),
            ),
          SizedBox(height: 12),
          Text(
            job.description,
            style: FigmaTextStyles().body16pt.copyWith(color: FigmaColors.darkDark0),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _mainModalBottomSheet({
  required BuildContext context,
  required String title,
  required Widget Function(StateSetter setModalState) builder,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return FractionallySizedBox(
            heightFactor: 0.95,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: FigmaColors.lightLight4,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      title,
                      style: FigmaTextStyles()
                          .stylizedMedium
                          .copyWith(color: FigmaColors.darkDark0),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: FigmaColors.lightLight0, thickness: 1),
                  SizedBox(height: 25),
                  Expanded(
                    child: builder(setModalState), // Contenu spécifique
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


void _showAddJobModal(BuildContext context) {
  final translationService = context.read<TranslationService>();
  TextEditingController descriptionController = TextEditingController();
  String? selectedCategoryId;
  String? selectedJobId;
  int experienceYears = 0; // Valeur initiale du curseur

  List<Category> categories = [];
  List<Job> jobs = [];
  bool isJobTextFieldEnabled = false;

  Future<void> loadCategories() async {
    final response = await http.get(Uri.parse('$routeAPI/api/categories/'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      categories = jsonData.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> loadJobsForCategory(String categoryId) async {
    final response = await http.get(Uri.parse('$routeAPI/api/categories/$categoryId'));
    if (response.statusCode == 200) {
      final resultJson = json.decode(response.body);
      final List<dynamic> jsonData = resultJson['professions_list'];
      jobs = jsonData.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs for category');
    }
  }

  _mainModalBottomSheet(
    context: context,
    title: 'Ajouter un métier',
    builder: (StateSetter setModalState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Sélection de catégorie
              buildTextField(
                onTap: () async {
                  await loadCategories();
                  final selectedCategory = await _showCategoryPicker(context, categories);
                  if (selectedCategory != null) {
                    setModalState(() {
                      selectedCategoryId = selectedCategory.id;
                      jobs.clear();
                      isJobTextFieldEnabled = false;
                      selectedJobId = null;
                    });
                    await loadJobsForCategory(selectedCategory.id);
                    setModalState(() {
                      isJobTextFieldEnabled = true;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                text: translationService.translate(categories
                    .firstWhere(
                      (category) => category.id == selectedCategoryId,
                      orElse: () => Category(id: '', name: ''),
                    )
                    .name),
              ),
              hintText:
                  translationService.translate('HINT_TEXT_SELECT_CATEGORY'),
              labelText:
                  translationService.translate('HINT_TEXT_SELECT_CATEGORY'),
              key: "selectCategoryField",
              ),
              const SizedBox(height: 10),

              // Sélection de métier
              if (isJobTextFieldEnabled)
                buildTextField(
                  onTap: () async {
                    final selectedJob = await _showJobPicker(context, jobs);
                    if (selectedJob != null) {
                      setModalState(() {
                        selectedJobId = selectedJob.id;
                      });
                    }
                  },
                  controller: TextEditingController(
                  text: translationService.translate(jobs
                        .firstWhere(
                          (job) => job.id == selectedJobId,
                          orElse: () => Job(id: '', name: ''),
                        )
                        .name),
                  ),
                  readOnly: true,
                  hintText: translationService.translate('HINT_TEXT_SELECT_JOB'),
                  labelText: translationService.translate('HINT_TEXT_SELECT_JOB'),
                  key: "selectJobField",
                ),
              const SizedBox(height: 10),

              // Description du métier
              if (selectedJobId != null)
                buildTextField(
                  controller: descriptionController,
                  maxLine: 5,
                  hintText: translationService.translate('HINT_TEXT_ADD_DESCRIPTION'),
                  labelText: translationService.translate('HINT_TEXT_ADD_DESCRIPTION'),
                  key: "descriptionField",
                ),
              const SizedBox(height: 10),

              // Années d'expérience
              if (selectedJobId != null)
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        '${translationService.translate("EXPERIENCE")}: ${experienceYears == 10 ? '10+' : experienceYears.toString()} ${translationService.translate("YEARS")}',
                        style: FigmaTextStyles().body16pt.copyWith(color: FigmaColors.darkDark0),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: experienceYears.toDouble(),
                        onChanged: (value) {
                          setModalState(() {
                            experienceYears = value.toInt();
                          });
                        },
                        min: 0,
                        max: 10,
                        divisions: 10,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Boutons d'action
          Column(
            children: [
              buildButton(
                onPressed: selectedJobId != null
                    ? () async {
                        await saveUserJobData(selectedJobId, descriptionController.text, experienceYears);
                        Navigator.pop(context);
                      }
                    : null,
                text: 'Ajouter',
              ),
              const SizedBox(height: 12),
              buildButton(
                variant: 'secondary',
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Annuler',
              ),
            ],
          )
        ],
      );
    },
  );
}

Future<void> saveUserJobData(String? selectedJobId, String description, int experienceYears) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('user_token');

  final jobsProvider = Provider.of<JobsProvider>(context, listen: false);

  final user = Provider.of<UserService>(context, listen: false);

  try {
    final response = await http.post(Uri.parse('$routeAPI/api/users/me/job'), body: {
      "profession_id": selectedJobId,
      "description": description,
      "experience_years": experienceYears.toString(),
    }, headers: {
      'Authorization': 'Bearer $userToken'
    });


    if (response.statusCode == 201) {
      final jobsList = jobsProvider.jobs;

      final jobName = jobsList.firstWhere((job) => job['id'] == selectedJobId,
        orElse: () =>
            {'name': 'Unknown'} // Retourne 'Unknown' si le job n'existe pas
        );

        if(selectedJobId != null){
         user.addNewJob(selectedJobId, jobName['name'], description, experienceYears);
        }
        setState(() {});
      
        NotificationService.showInfo(context, 'Mis à jour avec succès');
    } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, 'Échec de l\'enrigistrement');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, 'Erreur: $e');
    }
}

Future<Category?> _showCategoryPicker(BuildContext context, categories) async {
  final translationService = context.read<TranslationService>();
  return await showModalBottomSheet<Category>(
    context: context,
    builder: (BuildContext context) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(translationService.translate(categories[index].name)),
                  onTap: () {
                    Navigator.of(context).pop(categories[index]);
                  },
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

Future<Job?> _showJobPicker(BuildContext context, jobs) async {
  final translationService = context.read<TranslationService>();
  return await showModalBottomSheet<Job>(
    context: context,
    builder: (BuildContext context) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(translationService.translate(jobs[index].name)),
                  onTap: () {
                    Navigator.of(context).pop(jobs[index]);
                  },
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

  void _showEditModal(BuildContext context, Job job) {
  final translationService = context.read<TranslationService>();

  // Variables locales
  int experienceYears = job.experience_years;
  TextEditingController jobNameController =
      TextEditingController(text: translationService.translate(job.name));
  TextEditingController descriptionController =
      TextEditingController(text: job.description);

  _mainModalBottomSheet(
    context: context,
    title: 'Modifier ${translationService.translate(job.name)}',
    builder: (StateSetter setModalState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              buildTextField(
                controller: jobNameController,
                readOnly: true,
                hintText: job.name,
                labelText: 'Votre métier',
                key: 'jobNameField',
              ),
              SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      '${translationService.translate("EXPERIENCE")}: ${experienceYears == 10 ? '10+' : experienceYears.toString()} ${translationService.translate("YEARS")}',
                      style: FigmaTextStyles()
                          .body16pt
                          .copyWith(color: FigmaColors.darkDark0),
                    ),
                  ),
                  Slider(
                    value: experienceYears.toDouble(),
                    onChanged: (value) {
                      setModalState(() {
                        experienceYears = value.toInt();
                      });
                    },
                    min: 0,
                    max: 10,
                    divisions: 10,
                  ),
                ],
              ),
              SizedBox(height: 12),
              buildTextField(
                controller: descriptionController,
                maxLine: 5,
                minLine: 5,
                hintText: translationService
                    .translate('HINT_TEXT_ADD_DESCRIPTION'),
                labelText: translationService
                    .translate('HINT_TEXT_ADD_DESCRIPTION'),
                key: "descriptionField",
              ),
            ],
          ),
          Column(
            children: [
              buildButton(
                onPressed: () async {
                  // Logique de mise à jour ici
                  await updateJob(
                    job.id,
                    descriptionController.text,
                    experienceYears,
                  );
                  Navigator.pop(context);
                },
                text: 'Modifier',
              ),
              SizedBox(height: 12),
              buildButton(
                variant: 'delete',
                onPressed: () async {
                  await deleteJob(job.id);
                  Navigator.pop(context);
                },
                text: 'Supprimer',
              ),
            ],
          )
        ],
      );
    },
  );
}
Future<void> updateJob(jobID, description, experience_years) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');
    final user = Provider.of<UserService>(context, listen: false);

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
        if(jobID != null){
          user.updateUserJob(jobID, description, experience_years);
        }

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

    final user = Provider.of<UserService>(context, listen: false);

    try {
      final response = await http.delete(
          Uri.parse('$routeAPI/api/users/me/job/$jobID'),
          headers: {'Authorization': 'Bearer $userToken'});

      if (response.statusCode == 204) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        user.removeUserJobs(jobID);
        NotificationService.showInfo(
            context, 'Suppression effectuée avec succès');
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
  
}
