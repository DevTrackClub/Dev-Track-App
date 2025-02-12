import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';
import '../../std_details.dart';
import '../../common_pages/teamcard.dart';

class SpecificProject extends StatefulWidget {
  const SpecificProject({super.key});

  @override
  State<SpecificProject> createState() => _SpecificProjectState();
}

class _SpecificProjectState extends State<SpecificProject> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 40,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                size: 40,
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: const Text('1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.train,
                ),
                title: const Text('2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Team Name',
                  style: TextStyle(fontSize: 30),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 5, 28, 5),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 110,
                          width: 250,
                          color: Colors.grey[300],
                        ),
                        Container(
                          height: 30,
                          width: 300,
                          color: Colors.grey[300],
                          child: Center(child: Text('github link')),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About:',
                              style: TextStyle(fontSize: 20),
                            ),
                            Wrap(
                              children: [
                                ReadMoreText(
                                  'iuegfib hiuewiubvdsuig ugiuvbugiw gviugiugeuiwfhiviuweguihiwue uiguiuehf iuhjdkhu hdfoihfn ohnj ',
                                  trimLines: 2,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: "Show more",
                                  trimExpandedText: "Show less",
                                  moreStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  lessStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Team Members:',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Container(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: STD_details.stdlist.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: TeamCard(std: STD_details.stdlist[index]),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Upload Pdf'),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        height: 120,
                        width: 250,
                        color: Colors.grey[300],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
