import 'package:firebase_project/view/posts/add_post_view2.dart';
import 'package:firebase_project/viewModel/real_database_view_model.dart';
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
          stream: context.read<RealDatabaseViewModel>().streamData,
          builder: (context, snapshot) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {},
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hint: Text("Search data"),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("HI my name"),
                        subtitle: Text("1,23,34"),
                        trailing: PopupMenuButton(
                          onSelected: (value) {},
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 1, child: Text("Edit")),

                            PopupMenuItem(value: 2, child: Text("Delete")),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
