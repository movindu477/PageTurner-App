import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as file_picker;

class AddYourBookPage extends StatefulWidget {
  const AddYourBookPage({super.key});

  @override
  _AddYourBookPageState createState() => _AddYourBookPageState();
}

class _AddYourBookPageState extends State<AddYourBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedFile;
  String? _selectedImage;
  final List<String> _selectedSections = [];
  final List<String> _sections = [
    "Romantic",
    "Fantasy",
    "Horror",
    "Trending",
    "Latest"
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickFile() async {
    file_picker.FilePickerResult? result =
        await file_picker.FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.name;
      });
    }
  }

  void _pickImage() async {
    file_picker.FilePickerResult? result = await file_picker.FilePicker.platform
        .pickFiles(type: file_picker.FileType.image);
    if (result != null) {
      setState(() {
        _selectedImage = result.files.single.name;
      });
    }
  }

  void _publishBook() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Title: ${_titleController.text}');
      print('Description: ${_descriptionController.text}');
      print('Sections: ${_selectedSections.join(", ")}');
      print('Selected File: $_selectedFile');
      print('Selected Image: $_selectedImage');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book Published Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Your Book",
          style: TextStyle(color: Colors.white), // Changed text color
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: _selectedImage == null
                        ? const Text("Tap to upload an image",
                            style: TextStyle(color: Colors.black54))
                        : Text(_selectedImage!,
                            style: TextStyle(color: Colors.black87)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Section",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                children: _sections.map((section) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _selectedSections.contains(section),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedSections.add(section);
                            } else {
                              _selectedSections.remove(section);
                            }
                          });
                        },
                      ),
                      Text(section),
                    ],
                  );
                }).toList(),
              ),
              if (_selectedSections.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Selected: ${_selectedSections.join(", ")}",
                      style: TextStyle(fontSize: 14, color: Colors.black87)),
                ),
              const SizedBox(height: 16),
              const Text("Book Title",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the book title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the book title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a short description of the book',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickFile,
                child: Row(
                  children: const [
                    Icon(Icons.add_circle,
                        size: 30, color: Colors.deepPurpleAccent),
                    SizedBox(width: 8),
                    Text("Upload your document",
                        style: TextStyle(
                            fontSize: 16, color: Colors.deepPurpleAccent)),
                  ],
                ),
              ),
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Selected file: $_selectedFile",
                      style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 255, 255, 255))),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Increase button width
                child: ElevatedButton(
                  onPressed: _publishBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Publish",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
