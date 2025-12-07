import 'package:flutter/material.dart';
import 'package:mobile_computing_capstone/models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const JobCard({
    super.key,
    required this.job,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tags = job.getTagsList();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(isDarkMode ? 0.2 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.blue[900]
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      job.company,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? Colors.blue[200]
                            : Colors.blue.shade700,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    job.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: isDarkMode ? Colors.white : Colors.black87,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              if (job.salary != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.green[900]
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.green[700]!
                          : Colors.green.shade200,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 24,
                        color: isDarkMode
                            ? Colors.green[300]
                            : Colors.green.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${job.salary!.toStringAsFixed(0)}/year',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDarkMode
                              ? Colors.green[300]
                              : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    child: Text(
                      job.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDarkMode ? Colors.grey[300] : Colors.black54,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

              if (tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags
                        .take(5)
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.blue[900]
                                  : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.blue[700]!
                                    : Colors.blue.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDarkMode
                                    ? Colors.blue[200]
                                    : Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
