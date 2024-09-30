import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/job_badge_widget.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/utils.dart';

class UserListDisplay extends StatelessWidget {
  final Map<String, dynamic> user; // Liste des utilisateurs (image URL et nom)

  const UserListDisplay({super.key, required this.user});

  // Fonction pour obtenir les initiales d'un utilisateur
  String getInitials(String name) {
    List<String> nameParts = name.split(" ");
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0]; // Initiales des prénoms et noms
    } else {
      return nameParts[0]
          [0]; // Si le nom est un seul mot, on prend juste la première lettre
    }
  }

  String getUserName() {
    //if user has firstname so display firstname and lastname
    if (user['first_name'].isNotEmpty) {
      return '${FunctionUtils.capitalizeFirstLetter(user['first_name'])} ${FunctionUtils.capitalizeFirstLetter(user['last_name'])}';
    } else {
      return FunctionUtils.capitalizeFirstLetter(user['username']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    InkWell(
      onTap: () {
       Navigator.of(context, rootNavigator: true).pushNamed(
        RouteConstants.userInfo,
        arguments: [user['user_id']],
      );
      },
      child:
    Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: user['image_url'].isNotEmpty
                    ? NetworkImage(user['image_url'])
                    : null,
                child: user['image_url']?.isEmpty == true
                    ? Text(
                        getInitials(getUserName()), // Initiales si pas d'image
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null, // Pas de texte si une image est disponible
              ),
              const SizedBox(width: 8),
              Text(
                getUserName(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          //badges
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...(user['jobs'] ?? []).map((job) {
                    return JobBadge(jobId: job['profession_id'], isPro: job['pro']);
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}
