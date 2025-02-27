class TeamMember {
  final String name;
  final String branch;
  final String sem;
  final String link;

  TeamMember({required this.name, required this.branch, required this.sem, required this.link});

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      name: json['name'],
      branch: json['branch'],
      sem: json['sem'],
      link: json['link'],
    );
  }
}