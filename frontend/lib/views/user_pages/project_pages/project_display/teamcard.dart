import 'package:flutter/material.dart';



class TeamcardPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamcardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.values[0],
              children: const [
                Text('Team name.', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Project name', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Team no.', style: TextStyle(fontSize: 16)),
                  ],
                ),
                    SizedBox(height: 40),
                //idk this was there in the design....!!!
                //shuld i keep it...??
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       filled: true,
                //       fillColor: Colors.white,
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 16),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       filled: true,
                //       fillColor: Colors.white,
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Members'),
              Tab(text: 'Project'),
            ],
            indicatorColor: Colors.purple,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: Text('About Content')),
                MembersTab(),
                Center(child: Text('Project Content')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MembersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        memberCard('Nameeeee', 'Aiml', '6', 'in'),
        memberCard('Nameeeee', 'Aiml', '6', 'in'),
        memberCard('Nameeeee', 'Aiml', '6', 'in'),
        memberCard('Nameeeee', 'Aiml', '6', 'in'),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: GestureDetector(
            child: Text('edit members', style: TextStyle(color: Colors.purple)),
            onTap: () {
              // handle edit logic
            },
          ),
        ),
      ],
    );
  }

  Widget memberCard(String name, String branch, String sem, String link) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(branch),
                Text('Sem: $sem'),
              ],
            ),
            Text(link, style: TextStyle(color: Colors.purple)),
          ],
        ),
      ),
    );
  }
}