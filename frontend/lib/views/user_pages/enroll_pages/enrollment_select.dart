// lib/pages/enrollment_select_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dev_track_app/utils/topnavbar.dart';
import 'package:dev_track_app/theme/colors.dart';
import 'package:dev_track_app/view_models/enrollment_view_model.dart';
import 'package:dev_track_app/models/enrollment_model.dart';

class EnrollmentSelectPage extends StatefulWidget {
  final String username;

  const EnrollmentSelectPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<EnrollmentSelectPage> createState() => _EnrollmentSelectPageState();
}

class _EnrollmentSelectPageState extends State<EnrollmentSelectPage> {
  late EnrollmentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Initialize view model after the widget is inserted in the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<EnrollmentViewModel>(context, listen: false);
      _viewModel.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: TopNavBar(
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: Consumer<EnrollmentViewModel>(
        builder: (context, viewModel, child) {
          // Handle messages
          _handleMessages(viewModel);

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Greeting
                    Text(
                      "Hey, ${widget.username}!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTernaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      "Enroll now by giving basic details",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Preference 1 Dropdown
                    _buildPreferenceDropdown(
                      context: context,
                      viewModel: viewModel,
                      isFirst: true,
                      value: viewModel.firstPreference,
                      onChanged: viewModel.setFirstPreference,
                      hint: 'Preference 1',
                      transparentBg: true,
                    ),

                    // Caption for Preference 1
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 24),
                        child: Text(
                          'Select your First Preference',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.neutralLight,
                          ),
                        ),
                      ),
                    ),

                    // Preference 2 Dropdown
                    _buildPreferenceDropdown(
                      context: context,
                      viewModel: viewModel,
                      isFirst: false,
                      value: viewModel.secondPreference,
                      onChanged: viewModel.setSecondPreference,
                      hint: 'Preference 2',
                      transparentBg: false,
                    ),

                    // Caption for Preference 2
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Select your Second Preference',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.neutralLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom positioned Enroll button
              Positioned(
                left: 20,
                right: 20,
                bottom: 40,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        viewModel.isLoadingDomains || viewModel.isSubmitting
                            ? null
                            : _onEnrollPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      disabledBackgroundColor: AppColors.neutralLight,
                    ),
                    child: viewModel.isSubmitting
                        ? CircularProgressIndicator(
                            color: AppColors.textPrimaryLight)
                        : Text(
                            "ENROLL",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPreferenceDropdown({
    required BuildContext context,
    required EnrollmentViewModel viewModel,
    required bool isFirst,
    required Domain? value,
    required Function(Domain?) onChanged,
    required String hint,
    required bool transparentBg,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: transparentBg
            ? AppColors.primaryLight.withOpacity(0.05)
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutralLight.withOpacity(0.3)),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: viewModel.isLoadingDomains
          ? _buildLoadingIndicator()
          : _buildDropdown(viewModel.domains, value, onChanged, hint),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: CircularProgressIndicator(
        color: AppColors.primaryLight,
        strokeWidth: 2,
      ),
    ));
  }

  Widget _buildDropdown(List<Domain> domains, Domain? value,
      Function(Domain?) onChanged, String hint) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Domain>(
        value: value,
        isExpanded: true,
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            hint,
            style: TextStyle(color: AppColors.textSecondaryLight),
          ),
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryLight),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        borderRadius: BorderRadius.circular(8),
        items: domains.map((domain) {
          return DropdownMenuItem<Domain>(
            value: domain,
            child: Text(domain.name),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _handleMessages(EnrollmentViewModel viewModel) {
    // Show error message if any
    if (viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        viewModel.clearMessages();
      });
    }

    // Show success message if any
    if (viewModel.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        viewModel.clearMessages();

        // Here you can add navigation to the next page
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => SuccessPage()),
        // );
      });
    }
  }

  void _onEnrollPressed() async {
    final success = await _viewModel.submitEnrollment();
    if (success) {
      // Additional actions on success can be added here
    }
  }
}
