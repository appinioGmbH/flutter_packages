import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExampleCard extends StatelessWidget {
  final String image;

  const ExampleCard({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CupertinoColors.white,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Do you like the picture?",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 300,
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF053149),
                ),
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 20,
                    color: CupertinoColors.white,
                  ),
                ),
                height: 50,
                width: 300,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF053149),
                ),
                child: const Text(
                  "No",
                  style: TextStyle(
                    fontSize: 20,
                    color: CupertinoColors.white,
                  ),
                ),
                height: 50,
                width: 300,
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
