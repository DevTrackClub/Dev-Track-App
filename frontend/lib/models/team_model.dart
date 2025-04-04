class Team {
  final String id;
  final String name;
  final String domain;
  final List<TeamMember> members;

  Team({
    required this.id,
    required this.name,
    required this.domain,
    required this.members,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      domain: json['domain'],
      members: (json['members'] as List)
          .map((memberJson) => TeamMember.fromJson(memberJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domain': domain,
      'members': members.map((member) => member.toJson()).toList(),
    };
  }
}

class TeamMember {
  final String id;
  final String name;
  final String year;

  TeamMember({
    required this.id,
    required this.name,
    required this.year,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'],
      name: json['name'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'year': year,
    };
  }
}
