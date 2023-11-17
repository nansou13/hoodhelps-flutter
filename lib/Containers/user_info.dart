import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userInfo = {};
  String jobID = '';
  String jobName = '';

  bool isLoading = true;

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
    final List arguments = ModalRoute.of(context)!.settings.arguments as List;

    var userID = '';
    if (arguments.isNotEmpty) {
      userID = arguments[0].toString();
    }
    if (arguments.length >= 2) {
      setState(() {
        jobID = arguments[1].toString();
      });
    }

    //get user info
    try {
      final response = await http.get(Uri.parse('$routeAPI/api/users/$userID'));

      final userData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //recupere les jobs du users

        setState(() {
          userInfo = userData;
          isLoading = false;
        });
        return;
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, "Erreur User $userData");
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, "Erreur: ${e.toString()}");
    }
  }

  // Extrait en une fonction séparée pour réutilisation
  Future<void> _launchUri(Uri uri) async {
    final translationService = context.read<TranslationService>();
    if (!await canLaunchUrl(uri)) {
      // Remplacer par une gestion d'erreur appropriée.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "${translationService.translate("ERROR_ERROR_ON_ACTION")} : $uri"),
        ),
      );
    } else {
      await launchUrl(uri);
    }
  }

  // Les méthodes _makePhoneCall, _sendSMS, _sendEmail peuvent maintenant être simplifiées
  Future<void> _makePhoneCall(String phoneNumber) async =>
      _launchUri(Uri(scheme: 'tel', path: phoneNumber));
  Future<void> _sendSMS(String phoneNumber) async =>
      _launchUri(Uri(scheme: 'sms', path: phoneNumber));
  Future<void> _sendEmail(String emailAddress) async =>
      _launchUri(Uri(scheme: 'mailto', path: emailAddress));

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      final translationService = context.read<TranslationService>();

      var userUrl = userInfo['image_url'] ?? '';
      var allJobs = userInfo['jobs'] ?? [];

      dynamic currentJob;
      List<dynamic> otherJobs;

      if (allJobs.isNotEmpty) {
        currentJob = allJobs.firstWhere(
          (job) => job['id'].toString() == jobID,
          orElse: () => null,
        );

        // Filtrez le tableau pour obtenir les jobs qui n'ont pas l'id égal à jobID
        otherJobs =
            allJobs.where((job) => job['id'].toString() != jobID).toList();
      } else {
        // Gérez le cas où il n'y a pas de jobs ou la liste est vide
        currentJob = null;
        otherJobs = [];
      }

      return Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 35.0),
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              userUrl.isNotEmpty ? NetworkImage(userUrl) : null,
                          backgroundColor: Colors.blueGrey,
                          radius: 80.0,
                          child: Text(
                            userUrl.isEmpty
                                ? '${userInfo['first_name'].isNotEmpty ? userInfo['first_name'][0] : ''}${userInfo['last_name'].isNotEmpty ? userInfo['last_name'][0] : ''}'
                                    .toUpperCase()
                                : '',
                            style: const TextStyle(
                              fontSize: 70,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${userInfo['first_name']} ${userInfo['last_name']}',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (userInfo['phone_number']?.isNotEmpty ??
                              false) ...[
                            IconButton(
                              icon: const Icon(Icons.sms, color: Colors.white),
                              iconSize: 35,
                              onPressed: () =>
                                  _sendSMS(userInfo['phone_number']),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.phone, color: Colors.white),
                              iconSize: 35,
                              onPressed: () =>
                                  _makePhoneCall(userInfo['phone_number']),
                            ),
                          ],
                          if (userInfo['email']?.isNotEmpty ?? false)
                            IconButton(
                              icon:
                                  const Icon(Icons.email, color: Colors.white),
                              iconSize: 35,
                              onPressed: () => _sendEmail(userInfo['email']),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 10),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translationService
                                    .translate(currentJob['name']),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(
                                  '${translationService.translate('EXPERIENCE')} : ${currentJob['experience_years']} ${translationService.translate('YEARS')}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 20.0),
                              Text(translationService.translate('DESCRIPTION'),
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 10.0),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 24),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[
                                      100], // Couleur de fond de la boîte de citation
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300]!,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Assurez-vous que les enfants sont alignés au début de la croix
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        currentJob[
                                            'description'], // Description du job
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        otherJobs.isNotEmpty
                            ? ExpansionTile(
                                title: Text(
                                    translationService.translate('OTHER_JOBS')),
                                children: otherJobs.map<Widget>((job) {
                                  return ListTile(
                                    leading: Icon(IconsExtension.getIconData(job[
                                        'name'])), // Remplacer par une icône pertinente ou retirer si non nécessaire.
                                    title: Text(job['name']),
                                    onTap: () {
                                      // Code pour naviguer vers une nouvelle page.
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(
                                        '/userinfo',
                                        arguments: [userInfo['id'], job['id']],
                                      );
                                    }, // Assurez-vous que 'name' est la clé correcte pour le nom du métier.
                                  );
                                }).toList(),
                              )
                            : Container(), // ou bien SizedBox.shrink() pour un widget vide.
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    }
  }
}
