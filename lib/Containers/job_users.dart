import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:hoodhelps/utils.dart';
import 'package:http/http.dart' as http;

import 'package:hoodhelps/Containers/menu_widget.dart';
import 'package:provider/provider.dart';

class JobUsers extends StatefulWidget {
  const JobUsers({Key? key}) : super(key: key);

  @override
  _JobUsers createState() => _JobUsers();
}

class _JobUsers extends State<JobUsers> {
  String groupId = '';
  List category = [];
  List job = [];

  List usersData = [];
  bool isLoading =
      true; // Ajoutez une variable pour gérer l'affichage du loader

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadJobUsersData();
  }

  Future<void> _loadJobUsersData() async {
    final CategoriesService categoriesService = CategoriesService();
    final List arguments = ModalRoute.of(context)!.settings.arguments as List;
    var groupId = '';
    var categoryId = '';
    var jobId = '';
    if (arguments.isNotEmpty) {
      groupId = arguments[0].toString();
    }
    if (arguments.length >= 2) {
      categoryId = arguments[1].toString();
    }
    if (arguments.length >= 3) {
      jobId = arguments[2].toString();
    }

    var dataCateg = [];
    try {
      dataCateg = await categoriesService.getCacheCategoryData(groupId);
    } catch (e) {
      NotificationService.showError(context, e.toString());
    }

    // Filtrer les éléments de la liste avec le nom de catégorie correspondant
    var categoryData = dataCateg.firstWhere(
      (category) => category['id'] == categoryId,
      orElse: () => null,
    );

    List<dynamic> professionsData = [];
    if (categoryData != null) {
      professionsData = categoryData['professions'];
    }
    // Filtrer les éléments de la liste avec le nom de job correspondant
    var jobData = professionsData.firstWhere(
      (job) => job['profession_id'] == jobId,
      orElse: () => null,
    );
    try {
      final response = await http.get(
          Uri.parse('$routeAPI/api/categories/$groupId/jobs/$jobId/users'));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        setState(() {
          usersData = jsonDecode(response.body);
          groupId;
          category = [categoryId, categoryData['name']];
          job = [jobId, jobData['profession_name']];
          isLoading = false; // Arrêtez d'afficher le loader
        });
        return;
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, "Échec de la mise à jour $data");
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, "Erreur: ${e.toString()}");
    }
    setState(() {
      groupId;
      category = [categoryId, categoryData['name']];
      job = [jobId, jobData['name']];
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(translationService.translate(job[1])),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: translationService.translate('DISCONNECT_BUTTON'),
            onPressed: () {
              FunctionUtils.disconnectUser(context);
            },
          ),
        ],
      ),
      drawer: const MenuWidget(),
      body: Stack(
        children: [
          // Image de fond
          background(),
          Container(
            color: Colors.white.withOpacity(0.9),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
            padding: const EdgeInsets.all(
                16.0), // Marge uniforme autour de la grille
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 éléments par ligne
                crossAxisSpacing: 16.0, // Espace horizontal entre les éléments
                mainAxisSpacing: 16.0, // Espace vertical entre les éléments
              ),
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                final user = usersData[index];
                final userNameDisplay = displayName(user['first_name'], user['last_name'], user['username']);
                final userImageUrl = user['image_url'] ?? '';
                
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                        '/userinfo',
                        arguments: [user['id'], job[0], job[1], groupId],
                      );
                  },
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        CircleAvatar(
                          backgroundImage: userImageUrl.isNotEmpty ? NetworkImage(userImageUrl) : null,
                          backgroundColor: Colors.blueGrey,
                          radius: 50.0,
                          child: Text(
                            userImageUrl.isEmpty ? '${user['first_name'].isNotEmpty ? user['first_name'][0] : ''}${user['last_name'].isNotEmpty ? user['last_name'][0] : ''}'.toUpperCase(): '',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                            userNameDisplay,
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.center, // Centrer le texte
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ),
          ),
        ],
      ),
    );

    }
  }
}

String displayName(String? firstname, String? lastname, String? pseudo) {
  if (firstname != null && firstname.isNotEmpty) {
    if (lastname != null && lastname.isNotEmpty) {
      return "$firstname ${lastname[0]}.";  // e.g., "John D."
    } else {
      return firstname;  // e.g., "John"
    }
  } else if (pseudo != null && pseudo.isNotEmpty) {
    return pseudo;  // e.g., "john_doe"
  } else {
    return "Utilisateur anonyme";  // Fallback value
  }
}