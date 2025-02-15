import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const List<String> list = <String>[
  'AppDev-51',
  'AppDev-52',
  'WebDev-41',
  'WebDev-42'
];

class SubmissionPage extends StatefulWidget {
  @override
  _SubmissionPageState createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  String? _pdfPath;

  Future<void> _pickPdf() async {
    // Implement the file picking logic using a file picker package
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Allow only PDF files
    );

    if (result != null && result.files.isNotEmpty) {
      // Get the selected file
      final pickedFile = result.files.single;

      // Store the PDF path
      setState(() {
        _pdfPath = pickedFile.path; // File path of the selected PDF
      });

      // Print the PDF path for debugging
      print("Selected PDF: $_pdfPath");
    } else {
      // User canceled the picker
      print("No PDF selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submissions Page'),
        backgroundColor: Color.fromARGB(255, 19, 30, 45),
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Notification icon tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications tapped!')),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 19, 30, 45),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 19, 30, 45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonApp(),
                ),
                SizedBox(height: 20),
                _buildTextField(_githubController,
                    'Github link to project repo :', 'Add Your Link Here'),
                SizedBox(height: 20),
                _buildTextField(_youtubeController, 'Youtube link demo :',
                    'Add Your Link Here'),
                SizedBox(height: 20),
                _buildPdfUploadButton(),
                SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        hintText: hint,
        hintStyle: TextStyle(color: Color.fromARGB(255, 200, 200, 200)),
        filled: true,
        fillColor: Color.fromARGB(255, 1, 132, 67),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your link';
        }
        if (!Uri.parse(value).isAbsolute) {
          return 'Please enter a valid URL';
        }
        return null;
      },
    );
  }

  Widget _buildPdfUploadButton() {
    return InkWell(
      onTap: _pickPdf, // Opens file explorer
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              'Upload your project report here:',
              style: TextStyle(color: Colors.white),
            ),
            if (_pdfPath != null)
              Text(
                'Selected File: ${_pdfPath!.split('/').last}',
                style: TextStyle(color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate() && _pdfPath != null) {
          // Handle form submission
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form Submitted!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please complete all fields.')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 1, 132, 67),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        'Submit Now',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DropdownButtonApp extends StatefulWidget {
  const DropdownButtonApp({super.key});

  @override
  State<DropdownButtonApp> createState() => _DropdownButtonAppState();
}

class _DropdownButtonAppState extends State<DropdownButtonApp> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        isExpanded: true,
        icon: Icon(Icons.arrow_downward,
            color: Color.fromARGB(255, 255, 255, 255)),
        elevation: 16,
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        dropdownColor: Colors.grey[800],
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
