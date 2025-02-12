import 'package:flutter/material.dart';
import 'specific_project.dart';
import '../../../routing/previous_projects_routing.dart';

class PreviousProjects extends StatefulWidget {
  const PreviousProjects({super.key});

  @override
  State<PreviousProjects> createState() => _PreviousProjectsState();
}

class _PreviousProjectsState extends State<PreviousProjects> {
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
                    PreviousProjectsRouting.pop(context);
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
                PreviousProjectsRouting.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.train,
              ),
              title: const Text('2'),
              onTap: () {
                PreviousProjectsRouting.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'Nameeee',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText: 'Search all projects ....',
                    // suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                          ),
                          height: 90,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[800],
                                  ),
                                  height: 70,
                                  width: 70,
                                ),
                                SizedBox(
                                  width: 19,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'DOMAIN',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text('Project Name'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 320,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  PreviousProjectsRouting.pushToSpecificProject(
                                      context);
                                },
                                child: Text(
                                  'Learn More',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[800]),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                          ),
                          height: 90,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[800],
                                  ),
                                  height: 70,
                                  width: 70,
                                ),
                                SizedBox(
                                  width: 19,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'DOMAIN',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text('Project Name'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 320,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  PreviousProjectsRouting.pushToSpecificProject(
                                      context);
                                },
                                child: Text(
                                  'Learn More',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[800]),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                          ),
                          height: 90,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[800],
                                  ),
                                  height: 70,
                                  width: 70,
                                ),
                                SizedBox(
                                  width: 19,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'DOMAIN',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text('Project Name'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 320,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  PreviousProjectsRouting.pushToSpecificProject(
                                      context);
                                },
                                child: Text(
                                  'Learn More',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[800]),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                          ),
                          height: 90,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[800],
                                  ),
                                  height: 70,
                                  width: 70,
                                ),
                                SizedBox(
                                  width: 19,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'DOMAIN',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text('Project Name'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 320,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  PreviousProjectsRouting.pushToSpecificProject(
                                      context);
                                },
                                child: Text(
                                  'Learn More',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[800]),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                          ),
                          height: 90,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[800],
                                  ),
                                  height: 70,
                                  width: 70,
                                ),
                                SizedBox(
                                  width: 19,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'DOMAIN',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text('Project Name'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 320,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  PreviousProjectsRouting.pushToSpecificProject(
                                      context);
                                },
                                child: Text(
                                  'Learn More',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[800]),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
