import 'package:dev_track_app/api/team_service.dart';
import 'package:dev_track_app/models/team_model.dart';
import 'package:flutter/material.dart';

class MemberDragData {
  final TeamMember member;
  final String currentTeamId;

  MemberDragData(this.member, this.currentTeamId);
}

class TeamDashboardViewModel extends ChangeNotifier {
  final TeamService _teamService = TeamService();

  List<Team> _teams = [];
  List<Team> _originalTeams = []; // For tracking changes
  bool _isEditMode = false;
  bool _isLoading = true;
  bool _hasChanges = false;

  // Configuration
  final bool saveChangesManually =
      true; // Set to false for auto-save after each drag

  // Filter options
  String? _selectedDomain;
  String? _selectedYear;
  List<String> _domains = [];
  List<String> _years = [];

  TeamDashboardViewModel() {
    _loadTeams();
  }

  // Getters
  List<Team> get teams => _teams;
  List<Team> get filteredTeams {
    return _teams.where((team) {
      // If no filters are selected, show all teams
      if (_selectedDomain == null && _selectedYear == null) {
        return true;
      }

      // Apply domain filter if selected
      bool matchesDomain =
          _selectedDomain == null || team.domain == _selectedDomain;

      // Apply year filter if selected (this would normally filter team members, but for simplicity we're checking if any member matches)
      bool matchesYear = _selectedYear == null ||
          team.members.any((m) => m.year == _selectedYear);

      return matchesDomain && matchesYear;
    }).toList();
  }

  bool get isEditMode => _isEditMode;
  bool get isLoading => _isLoading;
  bool get hasChanges => _hasChanges;
  String? get selectedDomain => _selectedDomain;
  String? get selectedYear => _selectedYear;
  List<String> get domains => _domains;
  List<String> get years => _years;

  // Methods
  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  void setDomain(String domain) {
    _selectedDomain = domain;
    notifyListeners();
  }

  void setYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  Future<void> _loadTeams() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _teamService.getTeams();
      _teams = result;
      _originalTeams = _deepCopyTeams(result);

      // Extract unique domains and years for filters
      _extractFilterOptions();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // Handle error (in a real app, you might want to show an error message)
      debugPrint('Error loading teams: $e');
    }
  }

  void _extractFilterOptions() {
    final domainSet = <String>{};
    final yearSet = <String>{};

    for (final team in _teams) {
      domainSet.add(team.domain);

      for (final member in team.members) {
        yearSet.add(member.year);
      }
    }

    _domains = domainSet.toList()..sort();
    _years = yearSet.toList()..sort();
  }

  void moveMember(TeamMember member, String fromTeamId, String toTeamId) {
    // Find source and destination teams
    final fromTeamIndex = _teams.indexWhere((t) => t.id == fromTeamId);
    final toTeamIndex = _teams.indexWhere((t) => t.id == toTeamId);

    if (fromTeamIndex == -1 || toTeamIndex == -1) return;

    // Find the member in the source team
    final memberIndex =
        _teams[fromTeamIndex].members.indexWhere((m) => m.id == member.id);

    if (memberIndex == -1) return;

    // Create a copy of the member (to avoid reference issues)
    final memberToMove = TeamMember(
      id: member.id,
      name: member.name,
      year: member.year,
    );

    // Remove from source team
    _teams[fromTeamIndex].members.removeAt(memberIndex);

    // Add to destination team
    _teams[toTeamIndex].members.add(memberToMove);

    // Mark that we have changes
    _hasChanges = !_areTeamsEqual(_teams, _originalTeams);

    notifyListeners();

    // If we're auto-saving, call the API
    if (!saveChangesManually) {
      saveChanges();
    }
  }

  Future<void> saveChanges() async {
    if (!_hasChanges) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Call the API to update teams
      await _teamService.updateTeams(_teams);

      // Update original teams reference
      _originalTeams = _deepCopyTeams(_teams);
      _hasChanges = false;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // Handle error
      debugPrint('Error saving changes: $e');
    }
  }

  // Helper methods
  List<Team> _deepCopyTeams(List<Team> teams) {
    return teams.map((team) {
      return Team(
        id: team.id,
        name: team.name,
        domain: team.domain,
        members: team.members.map((member) {
          return TeamMember(
            id: member.id,
            name: member.name,
            year: member.year,
          );
        }).toList(),
      );
    }).toList();
  }

  bool _areTeamsEqual(List<Team> teams1, List<Team> teams2) {
    if (teams1.length != teams2.length) return false;

    for (int i = 0; i < teams1.length; i++) {
      final team1 = teams1[i];
      final team2 = teams2[i];

      if (team1.id != team2.id ||
          team1.name != team2.name ||
          team1.domain != team2.domain ||
          team1.members.length != team2.members.length) {
        return false;
      }

      // Check if all members are the same
      for (int j = 0; j < team1.members.length; j++) {
        final member1 = team1.members[j];
        final member2 = team2.members[j];

        if (member1.id != member2.id ||
            member1.name != member2.name ||
            member1.year != member2.year) {
          return false;
        }
      }
    }

    return true;
  }
}
