import 'package:flutter/material.dart';
import 'package:mobile_computing_capstone/database/database_helper.dart';
import 'package:mobile_computing_capstone/models/job.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _salaryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _applyUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _db = DatabaseHelper.instance;
  bool _isSubmitting = false;
  bool _isExpanded = false;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _salaryController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _applyUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitTestJob() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final parsedSalary = double.tryParse(_salaryController.text.trim());
    final tagsList = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    final tagsString = Job.tagsListToString(
      tagsList.isEmpty ? ['testing'] : tagsList,
    );

    final job = Job(
      title: _titleController.text.trim(),
      company: _companyController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'For testing'
          : _descriptionController.text.trim(),
      salary: parsedSalary,
      tags: tagsString,
      applyUrl: _applyUrlController.text.trim().isEmpty
          ? 'https://example.com/apply'
          : _applyUrlController.text.trim(),
    );

    try {
      await _db.insertJob(job);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Test job added.')));
      _formKey.currentState!.reset();
      _titleController.clear();
      _companyController.clear();
      _salaryController.clear();
      _descriptionController.clear();
      _tagsController.clear();
      _applyUrlController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add job: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                isDarkMode ? 'Dark mode is enabled' : 'Dark mode is disabled',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: widget.onThemeChanged,
                activeColor: Colors.blue,
                activeTrackColor: Colors.blue[200],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add a job (for testing)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Chip(
                    label: const Text('For testing'),
                    backgroundColor: isDarkMode
                        ? Colors.blueGrey
                        : Colors.blue[50],
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.blue[900],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              iconColor: isDarkMode ? Colors.white : Colors.black,
              collapsedIconColor: isDarkMode ? Colors.white : Colors.black,
              initiallyExpanded: _isExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          textInputAction: TextInputAction.next,
                          enabled: true,
                          enableInteractiveSelection: true,
                          decoration: const InputDecoration(
                            labelText: 'Job Title *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a job title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _companyController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Company *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a company name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _salaryController,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Salary (optional)',
                            hintText: 'e.g., 120000',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final parsed = double.tryParse(value.trim());
                              if (parsed == null) return 'Enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descriptionController,
                          textInputAction: TextInputAction.next,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description (optional)',
                            hintText: 'Defaults to "For testing"',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _tagsController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Tags (comma separated)',
                            hintText: 'e.g., flutter, mobile, remote',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _applyUrlController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                            labelText: 'Apply URL (optional)',
                            hintText: 'Defaults to example.com/apply',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isSubmitting ? null : _submitTestJob,
                            icon: _isSubmitting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.add),
                            label: Text(
                              _isSubmitting ? 'Adding...' : 'Add test job',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
