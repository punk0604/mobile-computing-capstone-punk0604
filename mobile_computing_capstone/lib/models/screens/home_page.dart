import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [
      Container(
        alignment: Alignment.center,
        color: Colors.blue,
        child: const Text('1', style: TextStyle(fontSize: 32, color: Colors.white)),
      ),
      Container(
        alignment: Alignment.center,
        color: Colors.red,
        child: const Text('2', style: TextStyle(fontSize: 32, color: Colors.white)),
      ),
      Container(
        alignment: Alignment.center,
        color: Colors.purple,
        child: const Text('3', style: TextStyle(fontSize: 32, color: Colors.white)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Swiper Home'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: 400,
          width: 300,
          child: CardSwiper(
            allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
            cardsCount: cards.length,
            cardBuilder: (context, index, percentX, percentY) => cards[index],
          ),
        ),
      ),
    );
  }
}
