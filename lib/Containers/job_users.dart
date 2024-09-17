import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/template_connected_page.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:http/http.dart' as http;

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
    final user = Provider.of<UserService>(context, listen: false);
    final List arguments = ModalRoute.of(context)!.settings.arguments as List;
    var groupId = user.currentGroupId;
    var categoryId = '';
    var jobId = '';

    if (arguments.length >= 1) {
      categoryId = arguments[0].toString();
    }

    if (arguments.length >= 2) {
      jobId = arguments[1].toString();
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
      return ConnectedPage(
        appTitle: translationService.translate(job[1]),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 éléments par ligne
            crossAxisSpacing: 16.0, // Espace horizontal entre les éléments
            mainAxisSpacing: 16.0, // Espace vertical entre les éléments
          ),
          itemCount: usersData.length,
          physics:
                const NeverScrollableScrollPhysics(), // Empêcher le GridView de défiler
            shrinkWrap:
                true, // Permettre au GridView de s'adapter à son contenu
          itemBuilder: (context, index) {
            final user = usersData[index];
            final userNameDisplay = displayName(
                user['first_name'], user['last_name'], user['username']);
            final userImageUrl = user['image_url'] ?? '';

            return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  RouteConstants.userInfo,
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
                      backgroundImage: userImageUrl.isNotEmpty
                          ? NetworkImage(userImageUrl)
                          : null,
                      backgroundColor: Colors.blueGrey,
                      radius: 50.0,
                      child: Text(
                        userImageUrl.isEmpty
                            ? '${user['first_name'].isNotEmpty ? user['first_name'][0] : ''}${user['last_name'].isNotEmpty ? user['last_name'][0] : ''}'
                                .toUpperCase()
                            : '',
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
      );
    }
  }
}

String displayName(String? firstname, String? lastname, String? pseudo) {
  if (firstname != null && firstname.isNotEmpty) {
    if (lastname != null && lastname.isNotEmpty) {
      return "$firstname ${lastname[0]}."; // e.g., "John D."
    } else {
      return firstname; // e.g., "John"
    }
  } else if (pseudo != null && pseudo.isNotEmpty) {
    return pseudo; // e.g., "john_doe"
  } else {
    return "Utilisateur anonyme"; // Fallback value
  }
}
