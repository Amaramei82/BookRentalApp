import 'dart:io';
import 'package:book_rental_system/services/data_service.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Re-add the import
import 'dart:ui';

class AdminBookManagementScreen extends StatefulWidget {
  const AdminBookManagementScreen({super.key});

  @override
  State<AdminBookManagementScreen> createState() => _AdminBookManagementScreenState();
}

class _AdminBookManagementScreenState extends State<AdminBookManagementScreen> {
  final DataService _dataService = DataService();

  void _showBookFormDialog({int? bookIndex, Map<String, String>? book}) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: book?['title']);
    final authorController = TextEditingController(text: book?['author']);
    final descriptionController = TextEditingController(text: book?['description']);
    String? selectedGenre = book?['genre'];
    String? imagePath = book?['image'];

    final List<String> genres = [
      'Science Fiction', 'Historical Fiction', 'Fantasy', 'Romance',
      'Thriller', 'Adventure', 'Personal Development', 'Self-Help'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(book == null ? 'Add New Book' : 'Update Book'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (v) => v!.isEmpty ? 'Title is required' : null,
                      ),
                      TextFormField(
                        controller: authorController,
                        decoration: const InputDecoration(labelText: 'Author'),
                        validator: (v) => v!.isEmpty ? 'Author is required' : null,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        validator: (v) => v!.isEmpty ? 'Description is required' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedGenre,
                        hint: const Text('Select Genre'),
                        items: genres.map((String genre) {
                          return DropdownMenuItem<String>(
                            value: genre,
                            child: Text(genre),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setDialogState(() {
                            selectedGenre = newValue;
                          });
                        },
                        validator: (v) => v == null ? 'Genre is required' : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              imagePath ?? 'No image selected.',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_library, color: darkGreen),
                            // Restore the image picker logic
                            onPressed: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setDialogState(() {
                                  imagePath = pickedFile.path;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() && imagePath != null) {
                      final newBookData = {
                        'title': titleController.text,
                        'author': authorController.text,
                        'genre': selectedGenre!,
                        'image': imagePath!,
                        'description': descriptionController.text,
                      };
                      if (bookIndex == null) {
                        _dataService.addBook(newBookData);
                      } else {
                        _dataService.updateBook(bookIndex, newBookData);
                      }
                      Navigator.of(context).pop();
                    } else if (imagePath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an image.')),
                      );
                    }
                  },
                  child: Text(book == null ? 'Add' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Management', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => _showBookFormDialog(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Book'),
                    onPressed: () => _showBookFormDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<List<Map<String, String>>>(
                  valueListenable: _dataService.booksNotifier,
                  builder: (context, books, child) {
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          elevation: 2.0,
                          color: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: book['image']!.startsWith('assets/')
                                  ? Image.asset(book['image']!, width: 50, fit: BoxFit.cover)
                                  : Image.file(File(book['image']!), width: 50, fit: BoxFit.cover),
                            ),
                            title: Text(book['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(book['author']!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showBookFormDialog(bookIndex: index, book: book),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _dataService.deleteBook(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
