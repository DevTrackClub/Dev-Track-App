// Team Member data model
class TeamMember {
  final String name;
  final String imageUrl;
  final String linkedInUrl;

  TeamMember({
    required this.name,
    required this.imageUrl,
    required this.linkedInUrl,
  });

  // TODO: Add fromJson constructor for API integration
  // factory TeamMember.fromJson(Map<String, dynamic> json) {
  //   return TeamMember(
  //     name: json['name'],
  //     imageUrl: json['image_url'],
  //     linkedInUrl: json['linkedin_url'],
  //   );
  // }
}

// Data model for specific project details
class SpecificProjectData {
  final String projectName;
  final String projectCycle;
  final String projectImage;
  final String description;
  final double progress;
  final String githubLink;
  final String projectLink;
  final List<TeamMember> teamMembers;

  SpecificProjectData({
    required this.projectName,
    required this.projectCycle,
    required this.projectImage,
    required this.description,
    required this.progress,
    required this.githubLink,
    required this.projectLink,
    required this.teamMembers,
  });

  // TODO: Add fromJson constructor for API integration
  // factory SpecificProjectData.fromJson(Map<String, dynamic> json) {
  //   return SpecificProjectData(
  //     projectName: json['project_name'],
  //     projectCycle: json['project_cycle'],
  //     projectImage: json['project_image'],
  //     description: json['description'],
  //     progress: json['progress'].toDouble(),
  //     githubLink: json['github_link'],
  //     projectLink: json['project_link'],
  //     teamMembers: (json['team_members'] as List)
  //         .map((member) => TeamMember.fromJson(member))
  //         .toList(),
  //   );
  // }
}

// Dummy data for development
final dummyProjectData = SpecificProjectData(
  projectName: "SAMPLE PROJECT",
  projectCycle: "Project Cycle 1",
  projectImage: "https://i.imgur.com/ea9PB3H.png",
  description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
      "Pellentesque at eros finibus, scelerisque elit at, iaculis "
      "massa. Phasellus a risus dolor.",
  progress: 0.69,
  githubLink: "https://github.com/sample/project",
  projectLink: "https://project-link.com",
  teamMembers: [
    TeamMember(
      name: "Piyush Chakarborthy",
      imageUrl: "https://i.imgur.com/GKPso4W.jpeg",
      linkedInUrl: "https://www.linkedin.com/in/piyushc2003/",
    ),
    TeamMember(
      name: "Jane Smith",
      imageUrl: "https://via.placeholder.com/150",
      linkedInUrl: "https://www.linkedin.com/in/janesmith",
    ),
    TeamMember(
      name: "Mike Johnson",
      imageUrl: "https://via.placeholder.com/150",
      linkedInUrl: "https://www.linkedin.com/in/mikejohnson",
    ),
    TeamMember(
      name: "Sarah Wilson",
      imageUrl: "https://via.placeholder.com/150",
      linkedInUrl: "https://www.linkedin.com/in/sarahwilson",
    ),
  ],
);
