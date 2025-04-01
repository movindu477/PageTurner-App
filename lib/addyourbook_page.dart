import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AddYourBookPage extends StatefulWidget {
  const AddYourBookPage({super.key});

  @override
  _AddYourBookPageState createState() => _AddYourBookPageState();
}

class _AddYourBookPageState extends State<AddYourBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedFile;
  File? _selectedImage;
  final List<String> _selectedSections = [];
  final List<String> _sections = [
    "Romantic",
    "Fantasy",
    "Horror",
    "Trending",
    "Latest"
  ];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _publishBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://localhost/flutter_API/Book_upload.php"),
      );

      // Add text fields
      request.fields["title"] = _titleController.text;
      request.fields["description"] = _descriptionController.text;
      request.fields["sections"] = jsonEncode(_selectedSections);

      // Add file if selected
      if (_selectedFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('file', _selectedFile!.path));
      }

      // Add image if selected
      if (_selectedImage != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', _selectedImage!.path));
      }

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print(responseData); // Debugging: Log the server response

      // Decode response
      final jsonResponse = jsonDecode(responseData);
      if (jsonResponse['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Book Published Successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Add Your Book", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
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
                        : Text("Selected Image",
                            style: const TextStyle(color: Colors.black87)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the book title',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the book title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a short description of the book',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the description'
                    : null,
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
                  child: Text(
                      "Selected file: ${_selectedFile!.path.split('/').last}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _publishBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Publish",
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
