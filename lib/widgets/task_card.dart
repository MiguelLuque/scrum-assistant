import 'package:flutter/material.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppTheme.cardSpacing),
      decoration: AppTheme.taskCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement task details view
          },
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing_md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                if (task.description != null) ...[
                  SizedBox(height: AppTheme.spacing_sm),
                  _buildDescription(),
                ],
                SizedBox(height: AppTheme.spacing_md),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            task.title,
            style: AppTheme.taskTitleStyle,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Implement task menu
          },
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      task.description!,
      style: AppTheme.taskDescriptionStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        _buildProgressIndicator(),
        const Spacer(),
        _buildAssigneeAvatar(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius_sm),
            child: LinearProgressIndicator(
              value: 0.6, // TODO: Add progress to TaskModel
              backgroundColor: AppTheme.progressBarBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.progressBarForeground,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssigneeAvatar() {
    return const CircleAvatar(
      radius: 14,
      backgroundColor: AppTheme.primaryColor,
      child: Icon(
        Icons.person,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}
