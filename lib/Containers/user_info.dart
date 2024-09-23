import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/job_badge_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/user_avatar_box.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userID = '';
  String jobID = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final List arguments = ModalRoute.of(context)!.settings.arguments as List;
    if (arguments.isNotEmpty) userID = arguments[0].toString();
    if (arguments.length >= 2) jobID = arguments[1].toString();
  }

  // Fetch user info and jobs asynchronously
  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('$routeAPI/api/users/$userID'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load user data");
      }
    } catch (e) {
      NotificationService.showError(context, "Erreur: ${e.toString()}");
      throw Exception(e);
    }
  }

  // Helper function to reorder jobs
  List<dynamic> _reorderJobs(List<dynamic> jobs, String jobID) {
    var currentJob = jobs.firstWhere((job) => job['id'].toString() == jobID,
        orElse: () => null);
    var otherJobs = jobs.where((job) => job['id'].toString() != jobID).toList();
    return currentJob != null ? [currentJob, ...otherJobs] : otherJobs;
  }

  // Generic launcher function
  Future<void> _launchUri(Uri uri) async {
    if (!await canLaunchUrl(uri)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error launching $uri")));
    } else {
      await launchUrl(uri);
    }
  }

  // Helper widgets for contact actions
  Widget _buildContactActionRow(IconData icon, String label, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        children: [
          Icon(icon, color: FigmaColors.darkDark0, size: 20),
          SizedBox(width: 5.0),
          Text(label,
              style: FigmaTextStyles()
                  .body16pt
                  .copyWith(color: FigmaColors.darkDark2)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.lightLight4, // Background color
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
                child: Text("Erreur de chargement des données"));
          }

          final userInfo = snapshot.data!;
          final translationService = context.read<TranslationService>();
          final reorderedJobs = _reorderJobs(userInfo['jobs'] ?? [], jobID);

          return Scaffold(
            backgroundColor: FigmaColors.lightLight4,
            appBar: genericAppBar(
              appTitle: FunctionUtils.getUserName(userInfo), // Affiche le username
              context: context,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(userInfo),
                  const SizedBox(height: 23.0),
                  Divider(color: FigmaColors.lightLight2, thickness: 1),
                  const SizedBox(height: 23.0),
                  Text('${translationService.translate("HINT_TEXT_JOB")}(s) :',
                      style: FigmaTextStyles()
                          .headingsh5
                          .copyWith(color: FigmaColors.darkDark0)),
                  const SizedBox(height: 10.0),
                  _buildJobList(reorderedJobs),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Profile header with contact options
  Widget _buildProfileHeader(Map<String, dynamic> userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatarBox(user: userInfo, size: 92.0),
        SizedBox(height: 15.0),
        _buildContactActionRow(Icons.email, userInfo['email'] ?? '',
            () => _launchUri(Uri(scheme: 'mailto', path: userInfo['email']))),
        SizedBox(height: 7.0),
        _buildContactActionRow(
            Icons.phone,
            FunctionUtils.formatPhoneNumber(userInfo['phone_number'] ?? ''),
            () =>
                _launchUri(Uri(scheme: 'tel', path: userInfo['phone_number']))),
        SizedBox(height: 7.0),
        _buildContactActionRow(
            Icons.sms,
            "Envoyer un SMS",
            () =>
                _launchUri(Uri(scheme: 'sms', path: userInfo['phone_number']))),
      ],
    );
  }

  // Job list with details
  Widget _buildJobList(List<dynamic> jobs) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: jobs.map((job) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: FigmaColors.lightLight3,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: FigmaColors.lightLight2, width: 2.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JobBadge(job_id: job['id']),
                  const SizedBox(height: 6),
                  Text(
                    '${job['experience_years']} année${job['experience_years'] > 1 ? 's' : ''} d\'expérience',
                    style: FigmaTextStyles()
                        .body14pt
                        .copyWith(color: FigmaColors.darkDark2),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    job['description'] ?? '',
                    style: FigmaTextStyles()
                        .body16pt
                        .copyWith(color: FigmaColors.darkDark0),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}