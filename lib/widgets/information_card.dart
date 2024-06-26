import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  const InformationCard(
      {super.key, required this.path, required this.stars, required this.text});

  final String path;
  final double stars;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 15),
      child: Card(
        color: const Color(0xFF2C595B),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Image.asset(
                path,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                // Left side with star icons and location icon
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          if (index >= stars) {
                            return const Icon(
                              Icons.star_border,
                              color: Color.fromARGB(255, 48, 48, 48),
                              size: 24,
                            );
                          } else {
                            return const Icon(
                              Icons.star,
                              color: Color(0xFFEDF9B9),
                              size: 24,
                            );
                          }
                        }),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFEDF9B9),
                        size: 24,
                      ),
                    ],
                  ),
                ),
                // Right side with text
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFFDAE3E5)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
