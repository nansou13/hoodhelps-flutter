import 'package:flutter/material.dart';

extension IconsExtension on Icons {
  static IconData getIconData(String iconName) {
    switch (iconName) {
      case "HEALTH_WELLBEING":
        return Icons.local_hospital;
      case "LEGAL_FINANCIAL":
        return Icons.attach_money;
      case "EDUCATION_TRAINING":
        return Icons.school;
      case "CRAFTSMANSHIP_CONSTRUCTION":
        return Icons.build;
      case "MAINTENANCE_REPAIR":
        return Icons.build;
      case "TECHNOLOGY_IT":
        return Icons.computer;
      case "BEAUTY_STYLE":
        return Icons.face;
      case "ANIMAL_SERVICES":
        return Icons.pets;
      case "GASTRONOMY":
        return Icons.restaurant;
      case "TRANSPORT_LOGISTICS":
        return Icons.local_shipping;
      case "REAL_ESTATE":
        return Icons.home;
      case "GENERAL_PRACTITIONER":
        return Icons.medical_services;
      case "PEDIATRICIAN":
        return Icons.child_friendly;
      case "NURSE":
        return Icons.medical_services;
      case "DENTIST":
        return Icons.local_hospital;
      case "PHYSIOTHERAPIST_OSTEOPATH_CHIROPRACTOR":
        return Icons.healing;
      case "NUTRITIONIST":
        return Icons.local_dining;
      case "PSYCHOLOGIST":
        return Icons.psychology;
      case "FITNESS_COACH":
        return Icons.fitness_center;
      case "BEAUTICIAN":
        return Icons.spa;
      case "LAWYER":
        return Icons.library_books;
      case "NOTARY":
        return Icons.library_books;
      case "ACCOUNTANT":
        return Icons.account_balance;
      case "FINANCIAL_ADVISOR":
        return Icons.account_balance;
      case "BAILIFF":
        return Icons.gavel;
      case "TEACHER":
        return Icons.school;
      case "MUSIC_TEACHER":
        return Icons.music_note;
      case "PROFESSIONAL_TRAINER":
        return Icons.fitness_center;
      case "CARPENTER":
        return Icons.build;
      case "PLUMBER":
        return Icons.build;
      case "ELECTRICIAN":
        return Icons.build;
      case "MASON":
        return Icons.build;
      case "PAINTER":
        return Icons.build;
      case "TILER":
        return Icons.build;
      case "MECHANIC":
        return Icons.build;
      case "BODYWORKER":
        return Icons.build;
      case "APPLIANCE_REPAIRER":
        return Icons.build;
      case "GARDENER":
        return Icons.nature_people;
      case "CLEANER":
        return Icons.cleaning_services;
      case "WEB_DEVELOPER":
        return Icons.code;
      case "NETWORK_ADMINISTRATOR":
        return Icons.network_check;
      case "COMPUTER_REPAIRER":
        return Icons.computer;
      case "UX_UI_DESIGNER":
        return Icons.design_services;
      case "HAIRDRESSER":
        return Icons.face;
      case "MAKEUP_ARTIST":
        return Icons.face;
      case "STYLIST":
        return Icons.face;
      case "MANICURIST":
        return Icons.face;
      case "VETERINARIAN":
        return Icons.local_hospital;
      case "GROOMER":
        return Icons.pets;
      case "PET_SITTER":
        return Icons.pets;
      case "ANIMAL_TRAINER":
        return Icons.pets;
      case "EXECUTIVE_CHEF":
        return Icons.restaurant;
      case "PASTRY_CHEF":
        return Icons.restaurant;
      case "SOMMELIER":
        return Icons.restaurant;
      case "BARISTA":
        return Icons.free_breakfast;
      case "TAXI_DRIVER":
        return Icons.local_taxi;
      case "MOVER":
        return Icons.local_shipping;
      case "REAL_ESTATE_AGENT":
        return Icons.home;
      case "PROPERTY_MANAGER":
        return Icons.home;
      default:
        return Icons.error; // Icône d'erreur par défaut si le nom de l'icône n'est pas trouvé
      }
  }
}


// Icon(
//       IconsExtension.getIconData(iconName), // Utilisez une extension pour obtenir l'icône correspondante
//       color: Colors.green,
//       size: 30.0,
//     ),