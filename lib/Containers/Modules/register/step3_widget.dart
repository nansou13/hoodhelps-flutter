import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Modules/register/progress_bar_widget.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/color_mapping.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/job_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:hoodhelps/services/icons_service.dart';

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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  int experienceYears = 0; // Valeur initiale du curseur
  bool isPro = false;

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
    final response = await ApiService().get('/categories');
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
    final response = await ApiService().get('/categories/$categoryId');
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
    try {
      final response = await ApiService().post(
        '/users/me/job',
        body: {
          "profession_id": selectedJobId,
          "description": descriptionController.text,
          "experience_years": experienceYears.toString(),
          "pro": isPro,
          "company_name": companyNameController.text,
        },
        useToken: true,
        context: context,
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        widget.nextStepCallback();
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
    return genericSafeAreaTwoBlocks(
        middleChild: Column(
          children: [
            ProgressBarWithCounter(currentStep: 3, totalSteps: 4),
            const SizedBox(height: 30.0),
            buildTextField(
              enabled: !isLoading,
              onTap: () {
                _showCategoryPicker(context);
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

            const SizedBox(height: 10), // Ajoute un espacement
            if (isJobTextFieldEnabled)
              buildTextField(
                enabled: isJobTextFieldEnabled,
                onTap: () {
                  // Utilisez onTap pour ouvrir la liste des emplois lorsqu'il est cliqué
                  if (isJobTextFieldEnabled) {
                    _showJobPicker(context);
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                  text: translationService.translate(jobs
                      .firstWhere(
                        (job) => job.id == selectedJobId,
                        orElse: () => Job(id: '', name: ''),
                      )
                      .name),
                ),
                hintText: translationService.translate('HINT_TEXT_SELECT_JOB'),
                labelText: translationService.translate('HINT_TEXT_SELECT_JOB'),
                key: "selectJobField",
              ),
            // Années d'expérience
                if (selectedJobId != null)
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '${translationService.translate("EXPERIENCE")}: ${experienceYears == 10 ? '10+' : experienceYears.toString()} ${translationService.translate("YEARS")}',
                          style: FigmaTextStyles()
                              .body16pt
                              .copyWith(color: FigmaColors.darkDark0),
                        ),
                      ),
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
                    ],
                  ),
                  if(selectedJobId != null)
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Je suis à mon compte :',
                          style: FigmaTextStyles()
                              .body16pt
                              .copyWith(color: FigmaColors.darkDark0),
                        ),
                      ),
                      SizedBox(width: 12),
                      Switch(
                        value: isPro,
                        onChanged: (value) {
                          setState(() {
                            isPro = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (isPro)
                  buildTextField(
                    controller: companyNameController,
                    hintText: 'Nom de l\'entreprise',
                    labelText: 'Nom de l\'entreprise',
                    key: 'companyNameField',
                  ),
            const SizedBox(height: 10),
            if (selectedJobId != null)
              buildTextField(
                enabled: selectedJobId != null,
                controller: descriptionController,
                maxLine: 2,
                hintText:
                    translationService.translate('HINT_TEXT_ADD_DESCRIPTION'),
                labelText:
                    translationService.translate('HINT_TEXT_ADD_DESCRIPTION'),
                key: "descriptionField",
              ),
          ],
        ),
        bottomChild: Column(
          children: [
            buildButton(
              onPressed: selectedJobId != null ? saveUserJobData : null,
              text: translationService.translate('ADD_THIS_JOB'),
            ),
            const SizedBox(height: 20.0),
            buildButton(
              variant: 'secondary',
              onPressed: () => widget.nextStepCallback(),
              text: translationService.translate('SKIP_BUTTON'),
            ),
          ],
        ));
  }

  Future<void> _showCategoryPicker(BuildContext context) async {
    final translationService = context.read<TranslationService>();
    final selectedCategory = await showModalBottomSheet<Category>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color:
                                    getColorByCategoryId(categories[index].id),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  IconsExtension.getIconData(
                                      categories[index].name),
                                  color: FigmaColors.lightLight4,
                                  size: 18,
                                ),
                              ),
                            ), // Affichez l'icône ici à gauche
                            const SizedBox(
                                width:
                                    10), // Ajoutez un espace entre l'icône et le texte
                            Expanded(
                              child: Text(
                                translationService
                                    .translate(categories[index].name),
                                style: FigmaTextStyles()
                                    .body16pt
                                    .copyWith(color: FigmaColors.darkDark0),
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
                Expanded(
                  child: ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: getColorByJobId(jobs[index].id),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  IconsExtension.getIconData(jobs[index].name),
                                  color: FigmaColors.lightLight4,
                                  size: 18,
                                ),
                              ),
                            ),

                            // Affichez l'icône ici à gauche
                            const SizedBox(
                                width:
                                    10), // Ajoutez un espace entre l'icône et le texte
                            Expanded(
                              child: Text(
                                translationService.translate(jobs[index].name),
                                style: FigmaTextStyles()
                                    .body16pt
                                    .copyWith(color: FigmaColors.darkDark0),
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
