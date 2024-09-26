import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Modules/user_update/circle_avatar_update.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = true;
  bool isMiniLoading = false;

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
        Navigator.of(context)
            .pushReplacementNamed(RouteConstants.registerLogin);
        return;
      }

      final userService = Provider.of<UserService>(context, listen: false);
      var userData = userService.getUser();

      setState(() {
        isLoading = false;
        usernameController.text = userData['username'] ?? '';
        emailController.text = userData['email'] ?? '';
        firstNameController.text = userData['first_name'] ?? '';
        lastNameController.text = userData['last_name'] ?? '';
        phoneController.text = userData['phone_number'] ?? '';
      });
      return;
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, "Erreur: ${e.toString()}");
    }
  }

  Future<void> updateUser() async {
    setState(() {
      isMiniLoading = true;
    });
    final firstname =
        FunctionUtils.capitalizeFirstLetter(firstNameController.text);
    final lastname =
        FunctionUtils.capitalizeFirstLetter(lastNameController.text);
    final phone = phoneController.text;
    final email = emailController.text;

    try {
      final response = await ApiService().put('/users/me',
          useToken: true,
          body: {
            'first_name': firstname,
            'last_name': lastname,
            'email': email,
            'phone_number': phone,
          },
          context: context);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        final userService = Provider.of<UserService>(context, listen: false);
        userService.updateUser(data);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.lightLight4,
      appBar: genericAppBar(
          context: context, appTitle: 'Mon profil'), // Background color
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                EditAvatar(),
                SizedBox(height: 20),
                _buildInfoSection(
                  [
                    _userValue(
                        title: 'Pseudo',
                        controller: usernameController,
                        isEditable: false),
                    _buildDivider(),
                    _userValue(
                        title: 'Prénom', controller: firstNameController),
                    _buildDivider(),
                    _userValue(title: 'Nom', controller: lastNameController),
                  ],
                ),
                SizedBox(height: 20),
                _buildInfoSection(
                  [
                    _userValue(title: 'E-Mail', controller: emailController),
                    _buildDivider(),
                    _userValue(title: 'Téléphone', controller: phoneController),
                  ],
                ),
              ],
            ),
          )),
      // Text('user data ${user}')
    );
  }

  Widget _userValue(
      {required String title,
      required TextEditingController controller,
      bool isEditable = true}) {
    final value = controller.text;
    return InkWell(
      onTap: () {
        if (isEditable) _showEditModal(context, title, controller);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: FigmaTextStyles()
                      .body14pt
                      .copyWith(color: FigmaColors.darkDark3)),
              Text(
                value,
                style: FigmaTextStyles()
                    .body16pt
                    .copyWith(color: FigmaColors.darkDark0),
              ),
            ],
          ),
          Icon(
            isEditable ? Icons.arrow_forward_ios : Icons.block,
            color: FigmaColors.darkDark0,
            size: 15,
          ),
        ],
      ),
    );
  }

  void _showEditModal(
      BuildContext context, String title, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.transparent, // Fond transparent pour permettre la mise en place de l'opacité
      isScrollControlled:
          true, // Permet de s'assurer que le clavier ne cache pas le modal
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.95, // 85% de la hauteur de l'écran
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
                  child: Text('Modifier $title',
                      style: FigmaTextStyles()
                          .stylizedMedium
                          .copyWith(color: FigmaColors.darkDark0)),
                ),
                SizedBox(height: 16),
                Divider(color: FigmaColors.lightLight0, thickness: 1),
                SizedBox(height: 25),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextField(
                        controller: controller,
                        hintText: title,
                        labelText: title,
                        key: title,
                      ),
                      buildButton(
                        onPressed: () async {
                          await updateUser();
                          Navigator.pop(context);
                        },
                        text: 'Enregistrer',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: FigmaColors.lightLight3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        SizedBox(height: 8),
        Divider(
          color: FigmaColors.lightLight1,
          thickness: 1,
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
