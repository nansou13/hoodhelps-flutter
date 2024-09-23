
import 'package:flutter/material.dart';
import 'package:hoodhelps/custom_colors.dart';

// Table de correspondance entre profession_id et couleurs
final Map<String, Color> jobColorMap = {
  'ba989c47-c963-45d7-a0d0-9b6f989d364f': FigmaColors.greenGreen1, // GENERAL_PRACTITIONER
  '890e2bb7-19eb-4e32-8a25-e71f06beea02': FigmaColors.greenGreen1, // PEDIATRICIAN
  'eae10000-8d0d-4e9e-8085-86248f0d9db2': FigmaColors.greenGreen1, // NURSE
  'e3f298ef-5d3e-4daf-b2f9-ab6b21e5f068': FigmaColors.greenGreen1, // DENTIST
  '361b0e1d-baeb-440d-8b61-1f77ca52788f': FigmaColors.greenGreen1, // PHYSIOTHERAPIST
  '0e1c7bec-9b84-49d8-8aba-806f5dc236fe': FigmaColors.greenGreen1, // NUTRITIONIST
  '7f644a02-ea83-42b2-a8d4-340a62fb4090': FigmaColors.greenGreen1, // PSYCHOLOGIST
  '6380d547-5466-4632-bcbd-f2c23b5b9bfa': FigmaColors.greenGreen1, // FITNESS_COACH
  '33fae10b-8e6c-4533-9e9e-56be72f0d155': FigmaColors.greenGreen1, // BEAUTICIAN
  '7ad8d99f-5b1e-4e71-8001-0aa90d140bf5': FigmaColors.blueBlue1, // LAWYER
  '4e7aa094-fe62-4abc-889c-76d03bb176d9': FigmaColors.blueBlue1, // NOTARY
  '3d9b1808-a86f-4b63-9426-aad4c2f183dc': FigmaColors.blueBlue1, // ACCOUNTANT
  'a9586750-31ab-4359-a6ec-39a0782be672': FigmaColors.blueBlue1, // FINANCIAL_ADVISOR
  'f7a24dad-6e0b-4294-b424-df00ccdfaf10': FigmaColors.blueBlue1, // BAILIFF
  'f64041d4-4e19-46bb-9344-5ab693a79745': FigmaColors.orangeOrange2, // TEACHER
  '86e524b6-1fbb-40cb-b5b4-0dfd1934b187': FigmaColors.orangeOrange2, // MUSIC_TEACHER
  'f9113c3c-a7b1-4afe-895b-d40f916c5a10': FigmaColors.orangeOrange2, // PROFESSIONAL_TRAINER
  '6d4f2310-8276-4224-890a-edefba2d66f5': FigmaColors.magentaMagenta0, // CARPENTER
  '0f3e75a3-7d82-4a92-ba37-ca4b24178feb': FigmaColors.magentaMagenta0, // PLUMBER
  '032fcedd-3601-43b2-9d33-2619350e0826': FigmaColors.magentaMagenta0, // ELECTRICIAN
  '7f595e8a-a02a-4885-93a3-631a06359443': FigmaColors.magentaMagenta0, // MASON
  '6f18b006-b3eb-485c-8520-a16b71ab5255': FigmaColors.magentaMagenta0, // PAINTER
  'e16ea713-ba15-493a-ae65-4ced59a6ffc3': FigmaColors.magentaMagenta0, // TILER
  '0266baba-1483-48a6-940d-8ed04957670e': FigmaColors.forestForest2, // MECHANIC
  'bd0a9838-2570-4519-bb92-8f0e6ef95793': FigmaColors.forestForest2, // BODYWORKER
  'a97c22fc-c487-4889-8ec9-5d1588336f00': FigmaColors.forestForest2, // APPLIANCE_REPAIRER
  '08e926c9-96db-4ad1-ac8f-f9fe2f5b28ef': FigmaColors.forestForest2, // GARDENER
  '080f75a8-0e0a-48f7-9abd-1c894850d3b2': FigmaColors.corailCorail1, // CLEANER
  'fef0b531-799f-4c11-b3da-ab84accd3f86': FigmaColors.corailCorail1, // BABYSITTER
  'c86ab516-9e1d-418b-82d0-ff1d611ec941': FigmaColors.corailCorail1, // NANNY
  '0543e471-8e69-4fc2-8eb8-d62187fa4f67': FigmaColors.skySky0, // WEB_DEVELOPER
  '5fdc7cf5-56b5-4535-819f-3ab671b78233': FigmaColors.skySky0, // NETWORK_ADMINISTRATOR
  '4d1569b6-b7cf-4a15-a6b4-655c56286193': FigmaColors.skySky0, // COMPUTER_REPAIRER
  '20de1dfd-17ab-4863-a3f1-1e1a4cfee914': FigmaColors.skySky0, // UX_UI_DESIGNER
  'bc4c99ee-892d-4cbc-ae2a-049e8e6b97bd': FigmaColors.pinkPink1, // HAIRDRESSER
  'e9511d5a-73ed-46c2-a8f1-e7e9bce9cfb3': FigmaColors.pinkPink1, // MAKEUP_ARTIST
  '1e1ac892-7615-433e-998a-bac1c39d906b': FigmaColors.pinkPink1, // STYLIST
  'be551d90-2974-41be-b1be-ec8bba42201b': FigmaColors.pinkPink1, // MANICURIST
  '8e192643-4585-4ed4-ac12-da044a50c924': FigmaColors.turquoiseTurquoise0, // VETERINARIAN
  '4426110a-e601-4e58-90f6-8fe57be55f40': FigmaColors.turquoiseTurquoise0, // GROOMER
  '57b8acf3-9227-459f-9041-70dd3827b841': FigmaColors.turquoiseTurquoise0, // PET_SITTER
  'd0fd50a3-0ae8-47de-9ff1-2c5c3c1164cd': FigmaColors.turquoiseTurquoise0, // ANIMAL_TRAINER
  '8d9370cc-a150-4af6-9cd2-029f3070fecd': FigmaColors.grapeGrape1, // EXECUTIVE_CHEF
  '23ec70eb-b449-455a-8638-7cd209ac2bd3': FigmaColors.grapeGrape1, // PASTRY_CHEF
  '59a5f0bd-4f4e-4043-9c1c-abb5d0c99ccc': FigmaColors.grapeGrape1, // SOMMELIER
  '6ea09060-d617-4304-a7e0-860d422274cc': FigmaColors.grapeGrape1, // BARISTA
  'cb204ab5-3cd6-4b22-850c-44d79e8c9162': FigmaColors.redRed2, // TAXI_DRIVER
  'f4f03f40-de85-49af-93cb-70a8cd83875b': FigmaColors.redRed2, // MOVER
  '162c8a32-8a93-49bd-8b3e-dca5b5c0eafb': FigmaColors.purplePurple3, // REAL_ESTATE_AGENT
  '37bbde19-ffb2-40ad-aa7c-5149e05ca095': FigmaColors.purplePurple3, // PROPERTY_MANAGER
};

// Fonction qui renvoie la couleur selon profession_id
Color getColorByJobId(String jobId) {
  return jobColorMap[jobId] ?? Colors.grey; // Default color if not found
}

final Map<String, Color> categoryColorMap = {
  '4954f51c-1c98-4847-8f1f-53b5de93a139': FigmaColors.greenGreen1, // HEALTH_WELLBEING (Médecins, Dentistes, etc.)
  '0798a2e9-5afd-45b9-94af-447a8c0e72d1': FigmaColors.blueBlue1, // LEGAL_FINANCIAL (Avocats, Notaires, etc.)
  '557f0135-d165-422c-a932-d4e0871411dd': FigmaColors.orangeOrange2, // EDUCATION_TRAINING (Enseignants, Formateurs, etc.)
  'a51ce3ce-0d32-4b7b-9980-f5942f2b12bc': FigmaColors.magentaMagenta0, // CRAFTSMANSHIP_CONSTRUCTION (Artisans, Électriciens, etc.)
  '65e492ff-87b2-48eb-9a98-22884e11853f': FigmaColors.forestForest2, // MAINTENANCE_REPAIR (Mécaniciens, Jardiniers, etc.)
  '9b8e37ea-76eb-4eb3-9aa2-9cbcb7f6f2f4': FigmaColors.skySky0, // TECHNOLOGY_IT (Développeurs, Techniciens réseau, etc.)
  'c9f70cfa-7487-4b26-a217-74e983bd98b6': FigmaColors.pinkPink1, // BEAUTY_STYLE (Coiffeurs, Esthéticiens, etc.)
  '3ff884fa-d72e-41ea-873c-f67aa77131a1': FigmaColors.turquoiseTurquoise0, // ANIMAL_SERVICES (Vétérinaires, Toiletteurs, etc.)
  '0ca97722-63dd-4123-8fdb-19d47a56c96b': FigmaColors.grapeGrape1, // GASTRONOMY (Chefs, Sommeliers, etc.)
  'b85d555a-18e2-4e0d-9b72-7ac416980146': FigmaColors.redRed2, // TRANSPORT_LOGISTICS (Chauffeurs, Déménageurs, etc.)
  '44810f02-4d31-4b68-918d-4f447e97a942': FigmaColors.purplePurple3, // REAL_ESTATE (Agents immobiliers, Gestionnaires, etc.)
};

// Fonction qui renvoie la couleur selon category_id
Color getColorByCategoryId(String categoryId) {
  return categoryColorMap[categoryId] ?? Colors.grey; // Default color if not found
}