import 'package:firebase_project/utils/utils_methods.dart';
import 'package:firebase_project/view/posts/add_post_view.dart';
import 'package:firebase_project/viewModel/auth_view_model.dart';
import 'package:firebase_project/viewModel/real_database_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final success = await Utils().showConfirmDialog(
            context,
            "Do you really want to sign out?",
          );
          if (!context.mounted) return;
          if (success) {
            await context.read<AuthViewModel>().signOut();
          }
        },
        child: Icon(Icons.logout),
      ),
      appBar: AppBar(
        title: Text("Post"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddPostView()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: context.read<RealDatabaseViewModel>().streamData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: Colors.blue);
            }
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              final dynamic rawData = snapshot.data!.snapshot.value;
              Map<dynamic, dynamic> map = rawData as Map<dynamic, dynamic>;
              //  List<dynamic> dataList = map.values.toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        context.read<RealDatabaseViewModel>().searchData(value);
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hint: Text("Search data"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<RealDatabaseViewModel>(
                      builder: (context, vm, child) {
                        final filterList = vm.filterData(map);

                        return ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (context, index) {
                            final post = filterList[index];
                            final String postId = post["id"]?.toString() ?? "";
                            final String postText = post["Data"] ?? "No title ";
                            return ListTile(
                              title: Text(postText),
                              subtitle: Text(post["serverTime"].toString()),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        myDialogBox(postId, postText);
                                      },
                                      child: Text("Edit"),
                                    ),
                                  ),

                                  PopupMenuItem(
                                    value: 2,
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text("No post yet"));
            }
          },
        ),
      ),
    );
  }

  //show snack bar for edit title
  void myDialogBox(String id, String currentText) {
    TextEditingController editingController = TextEditingController(
      text: currentText,
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: editingController,
            decoration: InputDecoration(hintText: "edit Text"),
          ),
          title: Text("Edit Title"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("cencel"),
            ),
            TextButton(
              onPressed: () async {
                await context.read<RealDatabaseViewModel>().updateData(
                  id,
                  editingController.text,
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: Text("ok"),
            ),
          ],
        );
      },
    );
  }
}
