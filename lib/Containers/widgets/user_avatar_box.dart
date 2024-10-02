import 'package:flutter/material.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';

class UserAvatarBox extends StatelessWidget {
  final dynamic user;
  final double? size;
  const UserAvatarBox({super.key, required this.user, double this.size = 50});
  // Fonction pour obtenir les initiales d'un utilisateur
  String getInitials() {
    String name = '';
    if (user is UserService) {
      name = (user as UserService).getUserName(); // Méthode pour obtenir le nom d'utilisateur à partir de UserService
    } else if (user is Map<String, dynamic>) {
      name = FunctionUtils.getUserName(user); // Obtenez le nom à partir du Map
    }

    List<String> nameParts = name.split(" ");
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0]; // Initiales des prénoms et noms
    } else {
      return nameParts[0][0].toUpperCase() + nameParts[0][1].toUpperCase(); // Si le nom est un seul mot, on prend juste la première lettre
    }
  }

  String getUserUrlImage() {
    if (user is UserService) {
      return (user as UserService).imageUrl ?? ''; // Obtenez l'URL de l'image à partir de UserService
    } else if (user is Map<String, dynamic>) {
      return user['image_url'] ?? ''; // Obtenez l'URL de l'image à partir du Map
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    var userUrl = getUserUrlImage();
    
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
                style: const FigmaTextStyles().headingsh1.copyWith(
                      color: FigmaColors.lightLight4,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            )
          : null,
    );
  }
}
