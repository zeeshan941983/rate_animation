import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_animation/widgets/customPaint.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  double value = 1;
  static const double minValue = 1;
  static const double maxValue = 3;
  Color endcolor = Color(0xffffdada);
  Color startcolor = Color(0xffdaffdb);
  late AnimationController controller;
  late Animation<double> okanimation;
  late Animation<double> badanimation;
  late Animation<double> goodanimation;
  late Animation<double> okeyeball;
  late Animation<double> badeyeball;
  late Animation<double> goodeyeball;
  late Animation containerColor;
  late Animation backgroundColor;
  String getExpression(double value) {
    if (value < 2) {
      return "Bad";
    } else if (value < 3) {
      return "Good";
    } else {
      return "OK";
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    okanimation = Tween<double>(
      begin: 0.4,
      end: 0.7,
    ).animate(controller);
    badanimation = Tween<double>(
      begin: 0.7,
      end: 0.5,
    ).animate(controller);
    goodanimation = Tween<double>(
      begin: 0.5,
      end: 0.9,
    ).animate(controller);

    badeyeball = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    goodeyeball = Tween<double>(
      begin: -10,
      end: -0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    okeyeball = Tween<double>(
      begin: 0.05,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    containerColor =
        ColorTween(begin: startcolor, end: endcolor).animate(controller);
    backgroundColor = ColorTween(begin: startcolor, end: Color(0xfffa9999))
        .animate(controller);
    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateColorTween(double value) {
    if (value < 2) {
      containerColor = ColorTween(begin: const Color(0xffdaffdb), end: endcolor)
          .animate(controller);
      backgroundColor =
          ColorTween(begin: const Color(0xffdaffdb), end: Color(0xfffa9999))
              .animate(controller);
    } else if (value < 3) {
      containerColor =
          ColorTween(begin: endcolor, end: startcolor).animate(controller);
      backgroundColor = ColorTween(
              begin: const Color(0xfffa9999), end: const Color(0xff9dfca1))
          .animate(controller);
    } else if (value < 4) {
      containerColor =
          ColorTween(begin: startcolor, end: const Color(0xffffffd9))
              .animate(controller);
      backgroundColor = ColorTween(
              begin: const Color(0xffffffd9), end: const Color(0xfffaf98b))
          .animate(controller);
    }
    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  color: backgroundColor.value,
                ),
                Positioned(
                  top: size.height * 0.015,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                        iconSize: WidgetStatePropertyAll(35),
                        shape: WidgetStatePropertyAll(CircleBorder()),
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.close)),
                ),
                Positioned(
                    top: 60,
                    left: size.width / 2 - 70,
                    child: Text(
                      "Ride Finished",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: ContainerClipper(),
                    child: Container(
                      height: size.height * 0.9,
                      decoration: BoxDecoration(
                        color: containerColor.value,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height / 6,
                  left: size.width * 0.1,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "How was \nyour ride ?",
                          style: GoogleFonts.poppins(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        getExpression(value),
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: CustomPaint(
                          painter: FacePainter(
                              okeyeball: okeyeball.value,
                              goodeyeball: goodeyeball.value,
                              badeyeball: badeyeball.value,
                              expressionValue: value,
                              okvalue: okanimation.value,
                              badvalue: badanimation.value,
                              goodvalue: goodanimation.value),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: Slider(
                          thumbColor: Colors.white,
                          inactiveColor: Colors.black38,
                          value: value,
                          min: minValue,
                          max: maxValue,
                          divisions: 2,
                          onChanged: (double newValue) {
                            setState(() {
                              value = newValue;
                              updateColorTween(value);
                            });
                            if (value < 2) {
                              controller.reset();
                              controller.forward();
                            } else if (value < 3) {
                              controller.reset();
                              controller.forward();
                            } else if (value < 4) {
                              controller.reset();
                              controller.forward();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: size.height * 0.10,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icon.png",
                            height: 30,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Add a comment",
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      CupertinoButton(
                          color: Colors.black,
                          child: const Text("Done"),
                          onPressed: () {})
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    ));
  }
}
