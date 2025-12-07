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
  late CardSwiperController controller;
  final DatabaseHelper _db = DatabaseHelper.instance;
  bool _isLoading = true;
  int _currentUserID = 1; // Default user ID

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final allJobs = await _db.getAllJobs();
      setState(() {
        jobs = allJobs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading jobs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _recordSwipe(Job job, bool isLike) async {
    try {
      final swipe = Swipe(
        userId: _currentUserID,
        jobId: job.id!,
        type: isLike ? 'like' : 'dislike',
      );
      await _db.insertSwipe(swipe);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Find Your Next Opportunity'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
          ? const Center(child: Text('No jobs available'))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CardSwiper(
                    controller: controller,
                    cardsCount: jobs.length,
                    cardBuilder:
                        (
                          context,
                          index,
                          horizontalThresholdPercentage,
                          verticalThresholdPercentage,
                        ) {
                          return JobCard(
                            job: jobs[index],
                            onSwipeLeft: () => _recordSwipe(jobs[index], false),
                            onSwipeRight: () => _recordSwipe(jobs[index], true),
                          );
                        },
                    onSwipe: (previousIndex, currentIndex, direction) {
                      if (previousIndex >= 0 && previousIndex < jobs.length) {
                        final job = jobs[previousIndex];
                        final isLike = direction == CardSwiperDirection.right;
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
                    numberOfCardsDisplayed: 2,
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
