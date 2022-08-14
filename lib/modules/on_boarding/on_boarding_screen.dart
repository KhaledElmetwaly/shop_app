import 'package:flutter/material.dart';
import 'package:shop_app/network/local/chache_helper.dart';
import 'package:shop_app/shop_app/login/login.dart';
import 'package:shop_app/themes/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var BoardController = PageController();
  bool isLast = false;
  void submit() {
    CasheHelper.saveDate(key: "onBoarding", value: true).then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) {
          return false;
        });
      }
    });
  }

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'lib/images/delivery.jpg',
      title: "onBoarding title 1",
      body: "onBoarding body 1",
    ),
    BoardingModel(
      image: 'lib/images/delivery.jpg',
      title: "onBoarding title 2",
      body: "onBoarding body 2",
    ),
    BoardingModel(
      image: 'lib/images/delivery.jpg',
      title: "onBoarding title 3",
      body: "onBoarding body 3",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: submit,
            child: const Text("SKIP"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
// print("lnot ast");

                  } else {
                    isLast = false;
                  }
                },
                physics: const BouncingScrollPhysics(),
                controller: BoardController,
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: 3,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: BoardController,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: DefaultColor,
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 5,
                      spacing: 5,
                    ),
                    count: boarding.length),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      BoardController.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios_sharp),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              // ignore: unnecessary_string_interpolations
              image: AssetImage("${model.image}"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            // ignore: unnecessary_string_interpolations
            "${model.title}",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            // ignore: unnecessary_string_interpolations
            "${model.body}",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
}
