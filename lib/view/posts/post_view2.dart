import 'package:firebase_project/view/posts/add_post_view2.dart';
import 'package:firebase_project/viewModel/firestore_database_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostView2 extends StatefulWidget {
  const PostView2({super.key});

  @override
  State<PostView2> createState() => _PostView2State();
}

class _PostView2State extends State<PostView2> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddPostView2()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: context.read<FirestoreDatabaseViewModel>().streamData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data ?? [];
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item["title"] ?? "no title"),
                  subtitle: Text(item["id"]),
                  trailing: Consumer<FirestoreDatabaseViewModel>(
                    builder: (context, vm, child) {
                      return PopupMenuButton(
                        onSelected: (value) {
                          if (value == 1) {
                            showMyDialog(item["id"], item["title"], vm);
                          } else {}
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 1, child: Text("Edit")),

                          PopupMenuItem(value: 2, child: Text("Delete")),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showMyDialog(
    String id,
    String currentText,
    FirestoreDatabaseViewModel vm,
  ) {
    TextEditingController editController = TextEditingController(
      text: currentText,
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Text'),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(hintText: "edit text"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              vm.updateData(id, {"title": editController.text});
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
