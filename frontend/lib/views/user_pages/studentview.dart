import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'package:dev_track_app/utils/imageuploadpage.dart'; // Ensure this is the correct path

class Studentview extends StatefulWidget {
  const Studentview({super.key});

  @override
  State<Studentview> createState() => _StudentviewState();
}

class _StudentviewState extends State<Studentview> {
  final double coverHeight = 280;
  final double profileHeight = 144;
  final double spacing = 40.0;

  Uint8List? _profileImage;
  Uint8List? _coverImage;
  String _aboutText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ac vestibulum erat. In elementum, dui non condimentum bibendum, purus magna viverra erat, nec elementum odio magna in risus.';

  // Placeholders for Ninja APIs
  String _name = ''; // Placeholder for name
  String _srn = ''; // Placeholder for SRN
  String _designation = ''; // Placeholder for designation
  String _profilePictureUrl = ''; // Placeholder for profile picture URL
  String _coverPictureUrl = ''; // Placeholder for cover picture URL

  @override
  void initState() {
    super.initState();
    _loadAboutInfo();
    _fetchMemberData(); // Fetch data from Ninja APIs or local storage
  }

  Future<void> _loadAboutInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _aboutText = prefs.getString('about_info') ?? _aboutText;
    });
  }

  Future<void> _saveAboutInfo(String aboutText) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('about_info', aboutText);
  }

  Future<void> _editAboutInfo() async {
    final newAbout = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _aboutText);
        return AlertDialog(
          title: Text('Edit About'),
          content: TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter new about info',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (newAbout != null && newAbout.isNotEmpty) {
      setState(() {
        _aboutText = newAbout;
      });
      _saveAboutInfo(_aboutText);
    }
  }

  Future<void> selectImage(ImageSource source, bool isProfileImage) async {
    Uint8List? img = await pickImage(source);
    if (img != null) {
      setState(() {
        if (isProfileImage) {
          _profileImage = img;
        } else {
          _coverImage = img;
        }
      });
    }
  }

  Future<void> _fetchMemberData() async {
    // This function will fetch data from Ninja APIs or local storage
    // Example placeholders (replace these with actual API calls)
    setState(() {
      _name = 'John Doe'; // Replace with API data
      _srn = 'SRN123456'; // Replace with API data
      _designation = 'Member'; // Replace with API data
      _profilePictureUrl = ''; // Replace with API data
      _coverPictureUrl = ''; // Replace with API data
    });
  }

  Widget build(BuildContext context) {
    // Get the height of the keyboard
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: keyboardHeight), // Adjust padding by keyboard height
        child: Column(
          children: [
            buildTop(),
            buildContent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEditOptions,
        child: Icon(Icons.edit),
        tooltip: 'Edit',
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns all children to the left
        children: [
          SizedBox(height: spacing), // Adjusted spacing
          Text(
            _name, // Name from API
            style: GoogleFonts.poppins(
              fontSize: 38.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'SRN: $_srn', // SRN from API
            style: GoogleFonts.poppins(
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            _designation, // Designation from API
            style: GoogleFonts.poppins(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'About',
            style: GoogleFonts.poppins(
              fontSize: 18.0, // Font size for "About" label
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            _aboutText,
            style: GoogleFonts.poppins(
              fontSize: 16.0, // Font size for the content
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: _coverImage != null
            ? Image.memory(
                _coverImage!,
                width: double.infinity,
                height: coverHeight,
                fit: BoxFit.cover,
              )
            : Image.network(
                _coverPictureUrl.isNotEmpty
                    ? _coverPictureUrl
                    : "https://img.freepik.com/free-photo/abstract-blur-empty-green-gradient-studio-well-use-as-background-website-template-frame-business-report_1258-52910.jpg",
                width: double.infinity,
                height: coverHeight,
                fit: BoxFit.cover,
              ),
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: _profileImage != null
            ? MemoryImage(_profileImage!) // Use the selected image
            : _profilePictureUrl.isNotEmpty
                ? NetworkImage(_profilePictureUrl)
                : AssetImage("assets/images/user.png")
                    as ImageProvider, // Use the default image
      );

  void _showEditOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Edit Profile Picture'),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery,
                      true); // Select and update profile picture
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Edit Cover Image'),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery,
                      false); // Select and update cover image
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit About'),
                onTap: () {
                  Navigator.pop(context);
                  _editAboutInfo(); // Edit and save about info
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
