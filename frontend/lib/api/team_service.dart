import 'dart:async';

import 'package:dev_track_app/models/team_model.dart';

class TeamService {
  // Mock delay to simulate network calls
  final Duration _mockDelay = const Duration(milliseconds: 800);

  // Sample data
  final List<Team> _mockTeams = [
    Team(
      id: 't1',
      name: 'Team Alpha',
      domain: 'Frontend',
      members: [
        TeamMember(id: 'm1', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm2', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm3', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm4', name: 'Nameeeee', year: '2025'),
      ],
    ),
    Team(
      id: 't2',
      name: 'Team Beta',
      domain: 'Backend',
      members: [
        TeamMember(id: 'm5', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm6', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm7', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm8', name: 'Nameeeee', year: '2025'),
      ],
    ),
    Team(
      id: 't3',
      name: 'Team Gamma',
      domain: 'Design',
      members: [
        TeamMember(id: 'm9', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm10', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm11', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm12', name: 'Nameeeee', year: '2025'),
      ],
    ),
    Team(
      id: 't4',
      name: 'Team Delta',
      domain: 'Mobile',
      members: [
        TeamMember(id: 'm13', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm14', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm15', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm16', name: 'Nameeeee', year: '2025'),
      ],
    ),
    Team(
      id: 't5',
      name: 'Team Epsilon',
      domain: 'DevOps',
      members: [
        TeamMember(id: 'm17', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm18', name: 'Nameeeee', year: '2025'),
        TeamMember(id: 'm19', name: 'Nameeeee', year: '2024'),
        TeamMember(id: 'm20', name: 'Nameeeee', year: '2024'),
      ],
    ),
  ];

  // Methods that would normally make API calls
  Future<List<Team>> getTeams() async {
    // Simulate API call delay
    await Future.delayed(_mockDelay);

    // Return a deep copy of the mock data to avoid reference issues
    return _mockTeams
        .map((team) => Team(
              id: team.id,
              name: team.name,
              domain: team.domain,
              members: team.members
                  .map((member) => TeamMember(
                        id: member.id,
                        name: member.name,
                        year: member.year,
                      ))
                  .toList(),
            ))
        .toList();
  }

  Future<void> updateTeams(List<Team> teams) async {
    // Simulate API call delay
    await Future.delayed(_mockDelay);

    // In a real app, this would send the updated teams to an API
    print('Teams updated successfully!');
    return;
  }
}
