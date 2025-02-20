import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/std_class.dart';

class TeamCard extends StatefulWidget {
  final STD std;
  const TeamCard({super.key, required this.std});

  @override
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: SizedBox(
          width: 150,
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,

            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10)
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(
                        10), // Adjust the radius as needed
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10), // Ensure the image fits within the rounded corners
                    child: Image.asset(
                      widget.std.profilepic,
                      width: double.infinity,
                      fit: BoxFit
                          .fill, // Use cover for better aspect ratio handling
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        final url = widget.std.linkedin;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Icon(Icons.person),
                    ),
                    Text(widget.std.name),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
