import 'package:flutter/material.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/utils.dart';

class UserAvatarBox extends StatelessWidget {
  final Map<String, dynamic> user;
  final double? size;
  UserAvatarBox({required this.user, double this.size = 48});
  // Fonction pour obtenir les initiales d'un utilisateur
  String getInitials() {
    String name = FunctionUtils.getUserName(user);

    List<String> nameParts = name.split(" ");
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0]; // Initiales des prénoms et noms
    } else {
      return nameParts[0]
          [0]; // Si le nom est un seul mot, on prend juste la première lettre
    }
  }

  @override
  Widget build(BuildContext context) {
    var userUrl = user['image_url'] ?? '';
    return Container(
      width: size, // Largeur du carré
      height: size, // Hauteur du carré
      decoration: BoxDecoration(
        color: FigmaColors.primaryPrimary0, // Couleur de fond
        borderRadius: BorderRadius.circular(10), // Bord arrondi
        image: userUrl.isNotEmpty // Si l'URL est non vide, affiche l'image
            ? DecorationImage(
                image: NetworkImage(userUrl), // Image utilisateur
                fit: BoxFit.cover, // Ajuste l'image au conteneur
              )
            : null,
      ),
      child: userUrl.isEmpty
          ? Center(
              child: Text(
                getInitials(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
