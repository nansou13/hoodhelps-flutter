import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hoodhelps/Containers/Widgets/job_badge_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/user_avatar_box.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';

class CategoryJobUsersMainListPage extends StatefulWidget {
  const CategoryJobUsersMainListPage({super.key});

  @override
  CategoryJobUsersMainListPageState createState() =>
      CategoryJobUsersMainListPageState();
}

class CategoryJobUsersMainListPageState
    extends State<CategoryJobUsersMainListPage> {
  String? categoryId;
  String? jobId;
  String jobName = '';
  bool isLoading = true;
  List usersData = [];
  Map<String, dynamic>? jobData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadJobsData(); // Appeler loadJobsData ici quand le contexte est prêt
  }

  Future<void> _loadJobsData() async {
    final List<dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>?;

    if (arguments == null || arguments.length != 2) {
      _showError('Invalid arguments');
      return;
    }

    try {
      final user = context.read<UserService>();
      final CategoriesService categoriesService = CategoriesService();

      setState(() {
        categoryId = arguments[0].toString();
        jobId = arguments[1].toString();
      });

      final groupId = user.currentGroupId;

      final categoryData = await _getCategoryData(categoriesService, groupId);

      if (categoryData == null) {
        _showError('Category data not found');
        return;
      }

      // Filtrer les éléments de la liste avec le nom de job correspondant
      jobData = _getJobDataFromCategory(categoryData);
      if (jobData == null) {
        _showError('Job data not found');
        return;
      }

      await _fetchUsersData(groupId, jobId!);
      setState(() {
        jobName = jobData?['profession_name'];
        isLoading = false;
      });
    } catch (e) {
      _showError('Erreur lors du chargement des données: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      isLoading = false;
    });
    NotificationService.showError( message);
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();

    return Scaffold(
      appBar: genericAppBar(
        appTitle: translationService.translate(jobName),
        context: context,
      ),
      backgroundColor: FigmaColors.lightLight4, // Fond noir pour toute la page
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (jobId == null || jobId!.isEmpty)
              ? _buildEmptyState(translationService)
              : _buildUsersList(),
    );
  }

  Widget _buildEmptyState(TranslationService translationService) {
    return Center(
      child: Text(translationService.translate('NO_CATEGORY_SELECTED')),
    );
  }

  Widget _buildUsersList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: usersData.map<Widget>((user) {
            final reorderedJobs =
                _reorderJobs(user['professions'] as List<dynamic>, jobId!);
            return _buildUserCard(user, reorderedJobs);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, List<dynamic> jobs) {
    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
        RouteConstants.userInfo,
        arguments: [user['id'], jobId],
      ),
      child: Container(
        padding: const EdgeInsets.all(14.0),
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: FigmaColors.lightLight3,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FigmaColors.lightLight2,
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildUserInfoRow(user),
            const SizedBox(height: 12),
            _buildJobBadges(jobs, isPro: user['pro'] ?? false),
            const SizedBox(height: 12),
            _buildUserDescription(user),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(Map<String, dynamic> user) {
    return Row(
      children: [
        UserAvatarBox(user: user),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FunctionUtils.getUserName(user),
              style: const FigmaTextStyles()
                  .body16pt
                  .copyWith(color: FigmaColors.darkDark0),
            ),
            Text(
              '${user['experience_years']} année${user['experience_years'] > 1 ? 's' : ''} d\'expérience',
              style: const FigmaTextStyles()
                  .body14pt
                  .copyWith(color: FigmaColors.darkDark2),
            ),
            if(user['pro'] == true)
            Row(
              children: [
                SvgPicture.asset(
            'assets/icons/building.svg',
                  width: 15,
                  height: 15,
                  semanticsLabel: 'Pro',
                  colorFilter: const ColorFilter.mode(
                    FigmaColors.darkDark2,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
              Text(
                '${user['company_name']}',
                style: const FigmaTextStyles()
                    .body14pt
                    .copyWith(color: FigmaColors.darkDark2),
              ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJobBadges(List<dynamic> jobs, {bool isPro = false}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: jobs.map((job) => JobBadge(
        jobId: job['profession_id'], // Accéder à l'ID de la profession
        isPro: job['pro'], // Accéder à la valeur pro
      )).toList(),
    ),
  );
}

  Widget _buildUserDescription(Map<String, dynamic> user) {
    return Text(
      user['description'] ?? '',
      style: const FigmaTextStyles().body16pt.copyWith(color: FigmaColors.darkDark0),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<Map<String, dynamic>?> _getCategoryData(
      CategoriesService categoriesService, String groupId) async {
    final data = await categoriesService.getCacheCategoryData(groupId);
    return data.firstWhere(
      (category) => category['id'] == categoryId,
      orElse: () => null,
    );
  }

  Map<String, dynamic>? _getJobDataFromCategory(
      Map<String, dynamic> categoryData) {
    final professions = categoryData['professions'] as List<dynamic>?;
    return professions?.firstWhere(
      (job) => job['profession_id'] == jobId,
      orElse: () => null,
    );
  }

  Future<void> _fetchUsersData(String groupId, String jobId) async {
    final response = await ApiService().get(
      '/categories/$groupId/jobs/$jobId/users',
      context: context,
    );

    if (response.statusCode == 200) {
      setState(() {
        usersData = jsonDecode(response.body);
      });
    } else {
      _showError('Erreur lors du chargement des données: ${response.body}');
    }
  }

  List<dynamic> _reorderJobs(List<dynamic> professions, String jobId) {
  return [
    professions.firstWhere((job) => job['profession_id'] == jobId, orElse: () => null),
    ...professions.where((job) => job['profession_id'] != jobId)
  ].where((job) => job != null).toList();
}
}
