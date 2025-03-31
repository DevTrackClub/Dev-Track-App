import 'package:dev_track_app/models/team_model.dart';
import 'package:dev_track_app/view_models/team_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TeamShufflePage extends StatelessWidget {
  const TeamShufflePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamDashboardViewModel(),
      child: const TeamDashboardView(),
    );
  }
}

class TeamDashboardView extends StatelessWidget {
  const TeamDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TeamDashboardViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Team Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: viewModel.isEditMode,
                        onChanged: (value) => viewModel.toggleEditMode(),
                        activeColor: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Filter section
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // Domain Dropdown
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: viewModel.selectedDomain,
                              hint: const Text('Domain'),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.purple),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  viewModel.setDomain(newValue);
                                }
                              },
                              items: viewModel.domains
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Year Dropdown
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: viewModel.selectedYear,
                              hint: const Text('Year'),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.purple),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  viewModel.setYear(newValue);
                                }
                              },
                              items: viewModel.years
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Team Lists
                  Expanded(
                    child: viewModel.isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.purple))
                        : ListView.builder(
                            itemCount: viewModel.filteredTeams.length,
                            itemBuilder: (context, index) {
                              final team = viewModel.filteredTeams[index];
                              return _buildTeamCard(context, team, viewModel);
                            },
                          ),
                  ),

                  // Save Button (only shown in edit mode)
                  if (viewModel.isEditMode && viewModel.saveChangesManually)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: viewModel.hasChanges
                            ? () => viewModel.saveChanges()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: viewModel.hasChanges
                                ? Colors.white
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard(
      BuildContext context, Team team, TeamDashboardViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            team.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DragTarget<MemberDragData>(
              onWillAccept: (data) =>
                  viewModel.isEditMode && data?.currentTeamId != team.id,
              onAccept: (data) {
                viewModel.moveMember(data.member, data.currentTeamId, team.id);
                HapticFeedback.mediumImpact(); // Vibration feedback on drop
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: candidateData.isNotEmpty
                        ? Border.all(color: Colors.purple, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: team.members.map((member) {
                      return viewModel.isEditMode
                          ? Draggable<MemberDragData>(
                              // Add onDragStarted callback to trigger haptic feedback
                              onDragStarted: () {
                                // Quick selection vibration when item is picked up
                                HapticFeedback.selectionClick();
                              },
                              data: MemberDragData(member, team.id),
                              feedback: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        member.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        member.year,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _buildMemberRow(member),
                              ),
                              child: _buildMemberRow(member),
                            )
                          : _buildMemberRow(member);
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberRow(TeamMember member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            member.name,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            member.year,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

//vibrator config

class HapticUtils {
  // Method for selection click haptic feedback
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }
}
