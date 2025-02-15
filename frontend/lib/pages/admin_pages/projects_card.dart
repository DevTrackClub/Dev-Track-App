import 'package:flutter/material.dart';

import 'package:dev_track_app/pages/user_pages/project_pages/project_display/specific_project.dart';

class Data {
  String domain_name;

  String content;

  Data({required this.domain_name, required this.content});
}

Widget ProjectsCard(List<Data> projectlist, int index, BuildContext contextt,
    Function onUpdate, Function onDelete) {
  TextEditingController _domainController =
      TextEditingController(text: projectlist[index].domain_name);
  TextEditingController _contentController =
      TextEditingController(text: projectlist[index].content);

  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(24, 61, 61, 1),
          ),
          height: 90,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Stack(
              children: [
                Row(
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
                          projectlist[index].domain_name,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          projectlist[index].content,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 20,
                  top: 10,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Container(
                      width: 30,
                      child: PopupMenuButton<int>(
                        offset: Offset(0, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Color(0xFF93B1A6),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Edit'),
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                  context: contextt,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: _domainController,
                                              cursorColor: Colors.black45,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                labelText: 'Edit Caption',
                                                labelStyle: TextStyle(
                                                    color: Colors.black45),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black38),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black45),
                                                ),
                                              ),
                                            ),
                                            TextField(
                                              controller: _contentController,
                                              cursorColor: Colors.black45,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                labelText: 'Edit Content',
                                                labelStyle: TextStyle(
                                                    color: Colors.black45),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black38),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black45),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                projectlist[index].domain_name =
                                                    _domainController.text;
                                                projectlist[index].content =
                                                    _contentController.text;
                                                onUpdate();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Update',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF93B1A6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Color(0xFF93B1A6),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Delete'),
                              ],
                            ),
                            onTap: () {
                              projectlist.removeAt(index);
                              onDelete();
                            },
                          ),
                        ],
                        iconColor: Color(0xFF93B1A6),
                      ),
                    ),
                  ),
                ),
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
                  Navigator.push(
                      contextt,
                      MaterialPageRoute(
                          builder: (context) => SpecificProject()));
                },
                child: Text(
                  'Learn More',
                  style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                ),
                style: ElevatedButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor: Colors.grey[400],
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
