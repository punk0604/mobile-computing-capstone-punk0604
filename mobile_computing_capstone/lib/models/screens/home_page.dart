import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:mobile_computing_capstone/database/database_helper.dart';
import 'package:mobile_computing_capstone/models/job.dart';
import 'package:mobile_computing_capstone/models/swipe.dart';
import 'package:mobile_computing_capstone/widgets/job_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Job> jobs = [];
  late List<Job> filteredJobs = [];
  late CardSwiperController controller;
  final DatabaseHelper _db = DatabaseHelper.instance;
  bool _isLoading = true;
  int _currentUserID = 1; // default user ID
  Set<String> selectedTags = {};
  List<String> allTags = [];

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final allJobs = await _db.getAllJobs();

      // Extract all unique tags
      Set<String> tagSet = {};
      for (var job in allJobs) {
        tagSet.addAll(job.getTagsList());
      }

      setState(() {
        jobs = allJobs;
        filteredJobs = allJobs;
        allTags = tagSet.toList()..sort();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading jobs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      if (selectedTags.isEmpty) {
        filteredJobs = jobs;
      } else {
        filteredJobs = jobs.where((job) {
          final jobTags = job.getTagsList();
          return selectedTags.any((tag) => jobTags.contains(tag));
        }).toList();
      }
    });
  }

  void _showFilterDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
              title: Text(
                'Filter by Tags',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedTags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              '${selectedTags.length} selected',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                setDialogState(() {
                                  selectedTags.clear();
                                });
                              },
                              child: const Text('Clear All'),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: allTags.map((tag) {
                          final isSelected = selectedTags.contains(tag);
                          return CheckboxListTile(
                            title: Text(
                              tag,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            value: isSelected,
                            activeColor: Colors.blue,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  selectedTags.add(tag);
                                } else {
                                  selectedTags.remove(tag);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilter();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _recordSwipe(Job job, bool isLike) async {
    try {
      final swipe = Swipe(
        userId: _currentUserID,
        jobId: job.id!,
        type: isLike ? 'like' : 'dislike',
      );
      await _db.insertSwipe(swipe);

      // If swiped right (like), save the job
      if (isLike) {
        await _db.toggleSaveJob(job.id!, true);
      }

      print('Recorded swipe: ${job.title} - ${isLike ? 'LIKE' : 'DISLIKE'}');
    } catch (e) {
      print('Error recording swipe: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: const Text('Find Your Next Opportunity'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
                tooltip: 'Filter by tags',
              ),
              if (selectedTags.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${selectedTags.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredJobs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No job postings found.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedTags.clear();
                        _applyFilter();
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedTags.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: isDarkMode ? Colors.grey[850] : Colors.blue[50],
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt,
                          size: 16,
                          color: isDarkMode
                              ? Colors.blue[300]
                              : Colors.blue[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filtered by: ${selectedTags.join(", ")}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode
                                  ? Colors.blue[300]
                                  : Colors.blue[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedTags.clear();
                              _applyFilter();
                            });
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: filteredJobs.isEmpty
                      ? const Center(child: Text('No jobs available'))
                      : CardSwiper(
                          controller: controller,
                          cardsCount: filteredJobs.length,
                          cardBuilder:
                              (
                                context,
                                index,
                                horizontalThresholdPercentage,
                                verticalThresholdPercentage,
                              ) {
                                return JobCard(
                                  job: filteredJobs[index],
                                  onSwipeLeft: () =>
                                      _recordSwipe(filteredJobs[index], false),
                                  onSwipeRight: () =>
                                      _recordSwipe(filteredJobs[index], true),
                                );
                              },
                          onSwipe: (previousIndex, currentIndex, direction) {
                            if (previousIndex >= 0 &&
                                previousIndex < filteredJobs.length) {
                              final job = filteredJobs[previousIndex];
                              final isLike =
                                  direction == CardSwiperDirection.right;
                              _recordSwipe(job, isLike);
                            }
                            return true;
                          },
                          onEnd: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No more jobs! You\'ve swiped through all available positions.',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          allowedSwipeDirection: AllowedSwipeDirection.only(
                            left: true,
                            right: true,
                          ),
                          numberOfCardsDisplayed: filteredJobs.length >= 2
                              ? 2
                              : 1,
                          backCardOffset: const Offset(40, 40),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.close),
                        label: const Text('Swipe Left'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.favorite),
                        label: const Text('Swipe Right'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
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
