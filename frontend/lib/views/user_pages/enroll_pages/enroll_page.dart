import 'package:dev_track_app/theme/colors.dart';
import 'package:dev_track_app/utils/topnavbar.dart';
import 'package:dev_track_app/view_models/enrollment_view_model.dart';
import 'package:dev_track_app/views/user_pages/enroll_pages/enrollment_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrollPage extends StatelessWidget {
  const EnrollPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EnrollmentViewModel()..fetchUser(),
      child: Consumer<EnrollmentViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: TopNavBar(
              onNotificationTap: () {},
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, EnrollmentViewModel viewModel) {
    final user = viewModel.user;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 150,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hey, ${user?.username ?? 'Guest'}!",
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Start your journey with Dev/Track",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: AppColors.textTernaryLight),
                ),
                const Text(
                  "Enroll now by giving basic details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EnrollmentSelectPage(
                              username: user?.username ?? ''),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text(
                      "Enroll",
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
