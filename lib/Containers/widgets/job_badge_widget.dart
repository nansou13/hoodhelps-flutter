import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hoodhelps/color_mapping.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/services/jobs_provider.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';

class JobBadge extends StatelessWidget {
  final String jobId;
  final bool isPro;

  const JobBadge({super.key, required this.jobId, this.isPro = false});

  String getJobNameById(BuildContext context, String id) {
    final jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    final translationService = context.read<TranslationService>();
    final jobs = jobsProvider.jobs;

    final job = jobs.firstWhere((job) => job['id'] == id,
        orElse: () =>
            {'name': 'Unknown'} // Retourne 'Unknown' si le job n'existe pas
        );
    return translationService.translate(job['name']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0), // Espacement entre les badges
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: getColorByJobId(jobId), // Fond du badge
          borderRadius: BorderRadius.circular(100), // Bordure arrondie
        ),
        child: 
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          Text(
            getJobNameById(context, jobId),
            style: const FigmaTextStyles().stylizedLead.copyWith(
                  color: FigmaColors.lightLight4,
                ),
          ),
          if (isPro)
          SvgPicture.asset(
            'assets/icons/medal.svg',
            width: 20,
            height: 20,
            semanticsLabel: 'Pro',
            colorFilter: const ColorFilter.mode(
              FigmaColors.lightLight4,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
        
      ),
    );
  }
}
