// ignore_for_file: inference_failure_on_function_invocation

import 'package:app_ui/app_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  const PostCard({required this.post, required this.callBack, super.key});
  final Map<String, dynamic> post;
  final VoidCallback callBack;

  @override
  Widget build(BuildContext context) {
    String formatTimestamp(Timestamp timestamp) {
      final dateTime = timestamp.toDate();

      return timeago.format(dateTime);
    }

    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: callBack,
      child: Card(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post['userName']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatTimestamp(post['timestamp'] as Timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: .5, color: AppColors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${post['content']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: .5, color: AppColors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.comment,
                      color: AppColors.black,
                    ),
                    // Text('${post['id']['comments']}')
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
