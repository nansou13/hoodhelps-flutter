import 'package:flutter/material.dart';
import 'package:hoodhelps/custom_colors.dart';

class UserAvatar {
  final String name;
  final String image;

  UserAvatar({required this.name, required this.image});
}

class AvatarStack extends StatelessWidget {
  final List<UserAvatar> users; // Liste des utilisateurs (image URL et nom)
  final int maxAvatars = 4; // Limite d'avatars à afficher

  AvatarStack({required this.users});

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

  @override
  Widget build(BuildContext context) {
    int remainingUsers =
        users.length - maxAvatars; // Nombre d'utilisateurs supplémentaires

    return Row(
      children: [
        // Stack pour superposer les avatars
        SizedBox(
          height: 30, // Taille explicite pour le stack
          width: (15.0 * maxAvatars) +
              15, // Largeur en fonction du nombre d'avatars
          child: Stack(
            children: List.generate(
              users.length > maxAvatars ? maxAvatars : users.length,
              (index) {
                return Positioned(
                  left: index * 15.0, // Décalage horizontal pour chevauchement
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: users[index].image.isNotEmpty
                        ? NetworkImage(
                            users[index].image) // Image de l'utilisateur
                        : null, // Si pas d'image, on met un fond vide
                    child: users[index].image.isEmpty
                        ? Text(
                            getInitials(
                                users[index].name), // Initiales si pas d'image
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null, // Pas de texte si une image est disponible
                  ),
                );
              },
            ),
          ),
        ),
        // Afficher "+X" si plus de 4 utilisateurs
        if (users.length > maxAvatars)
          Padding(
            padding: const EdgeInsets.only(left: 10.0), // Espacement avant "+X"
            child: Text(
              '+$remainingUsers',
              style: FigmaTextStyles().body14pt.copyWith(
                    color: FigmaColors.lightLight0,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
          ),
      ],
    );
  }
}
