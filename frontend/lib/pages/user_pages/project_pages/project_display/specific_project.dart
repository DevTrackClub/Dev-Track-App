import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dev_track_app/theme/colors.dart';
import 'package:dev_track_app/utils/topnavbar.dart';
import 'package:dev_track_app/models/new_specific_projectModels.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember member;

  const TeamMemberCard({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.primaryLight.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                member.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 100),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              member.name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.textPrimaryLight),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final Uri url = Uri.parse(member.linkedInUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.link, size: 16, color: AppColors.textPrimaryLight),
                  SizedBox(width: 4),
                  Text(
                    "LinkedIn",
                    style: TextStyle(color: AppColors.textPrimaryLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the dummy data from models
    final projectData = dummyProjectData;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: TopNavBar(
        onNotificationTap: () {
          // Open notifications page
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              projectData.projectName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),

            Text(
              projectData.projectCycle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  dummyProjectData.projectImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint("Error loading image: $error");
                    return const Icon(
                      Icons.image_search,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: projectData.progress,
                    minHeight: 6,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 8),
                Text("${(projectData.progress * 100).round()}%"),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              "About",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            Text(
              projectData.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.4,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final Uri url = Uri.parse(projectData.githubLink);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text("Github-Link"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final Uri url = Uri.parse(projectData.projectLink);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text("Link"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              "Team Members",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Horizontal scrollable team members
            SizedBox(
              height: 220, // Fixed height for the scroll view
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: projectData.teamMembers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 16,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: SizedBox(
                      width: 160, // Fixed width for each card
                      child: TeamMemberCard(
                          member: projectData.teamMembers[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
