import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_computing_capstone/database/database_helper.dart';
import 'package:mobile_computing_capstone/models/job.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  late Future<List<Job>> _savedJobs;

  @override
  void initState() {
    super.initState();
    _loadSavedJobs();
  }

  void _loadSavedJobs() {
    setState(() {
      _savedJobs = _db.getSavedJobs();
    });
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error launching URL: $e')));
      }
    }
  }

  Future<void> _toggleSave(Job job) async {
    await _db.toggleSaveJob(job.id!, false);
    _loadSavedJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text('Saved Jobs'),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Job>>(
        future: _savedJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final jobs = snapshot.data ?? [];

          if (jobs.isEmpty) {
            return const Center(
              child: Text(
                'No saved jobs yet.\nSwipe right to save jobs!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return SavedJobCard(
                job: job,
                onTap: () => _launchUrl(job.applyUrl),
                onUnsave: () => _toggleSave(job),
              );
            },
          );
        },
      ),
    );
  }
}

class SavedJobCard extends StatefulWidget {
  final Job job;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  const SavedJobCard({
    super.key,
    required this.job,
    required this.onTap,
    required this.onUnsave,
  });

  @override
  State<SavedJobCard> createState() => _SavedJobCardState();
}

class _SavedJobCardState extends State<SavedJobCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: const Icon(Icons.work, color: Colors.blue),
            title: Text(
              widget.job.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              widget.job.company,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            trailing: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.blue,
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.job.salary != null) ...[
                    const Text(
                      'Salary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '\$${widget.job.salary!.toStringAsFixed(0)}/year',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.job.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  if (widget.job.getTagsList().isNotEmpty) ...[
                    const Text(
                      'Tags',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.job
                          .getTagsList()
                          .take(5)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.blue[50],
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onTap,
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Apply'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: widget.onUnsave,
                        icon: const Icon(Icons.delete),
                        label: const Text('Unsave'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
