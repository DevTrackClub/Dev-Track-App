import 'package:flutter/material.dart';

import 'projects_card.dart';

class MgmtPreviousProjects extends StatefulWidget {
  const MgmtPreviousProjects({super.key});

  @override
  State<MgmtPreviousProjects> createState() => _MgmtPreviousProjectsState();
}


class _MgmtPreviousProjectsState extends State<MgmtPreviousProjects> {
  List<Data> posts = [
    Data(
      domain_name: 'Game Dev ',

      content: 'Gobi Subramani',
    ),
    Data(
      domain_name: 'App Dev ',

      content: 'DevTrackApp ',
    ),
  ];
  void _updateState() {
    setState(() {});
  }

  void _deleteState() {
    setState(() {});
  }

  void _addState(String cap, String con) {
    setState(() {
      posts.insert(0, Data(domain_name: cap, content: con));
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _domainAdder = TextEditingController();
    TextEditingController _contentAdder = TextEditingController();
    String newdom = '.';
    String newcon = '.';

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            foregroundColor: Colors.white,

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
            backgroundColor: Colors.black,
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
          body: Column(
            children: [
              Container(
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
                            style: TextStyle(fontSize: 25,color: Colors.white),
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
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return ProjectsCard(
                            posts, index, context, _updateState, _deleteState);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _domainAdder,
                              cursorColor: Colors.black45,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Add Caption',
                                labelStyle: TextStyle(color: Colors.black45),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black38),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45),
                                ),
                              ),
                            ),
                            TextField(
                              controller: _contentAdder,
                              cursorColor: Colors.black45,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Add Content',
                                labelStyle: TextStyle(color: Colors.black45),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black38),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                newdom = _domainAdder.text;
                                newcon = _contentAdder.text;
                                _addState(newdom, newcon);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'done',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Color(0xFF93B1A6), // Custom button color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            backgroundColor: Color(0xFF93B1A6),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        )
    );

  }
}
