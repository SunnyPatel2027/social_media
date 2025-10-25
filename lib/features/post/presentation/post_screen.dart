import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/common_snackbar.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../cubit/post_cubit.dart';
import '../cubit/post_state.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final messageCtrl = TextEditingController();
  final messageFocusNode = FocusNode();

  @override
  void dispose() {
    messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Social Media'),
          automaticallyImplyLeading: false,
          actions: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    final authCubit = context.read<AuthCubit>();
                    if (authCubit.state.isLoading) return;
                    await authCubit.signOut();
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageCtrl,
                      focusNode: messageFocusNode,
                      onTapUpOutside: (event) => messageFocusNode.unfocus(),
                      decoration: const InputDecoration(
                        hintText: 'Write a message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final m = messageCtrl.text.trim();
                      if (m.isEmpty) return;
                      context.read<PostCubit>().createPost(m);
                      messageCtrl.clear();
                      showSnackBar(context, 'Posted');
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<PostCubit, PostState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(child: Text(state.error!));
                  }
                  if (state.posts.isEmpty) {
                    return const Center(child: Text('No posts yet'));
                  }
                  return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      final p = state.posts[index];
                      return ListTile(
                        title: Text(p.message),
                        subtitle: Text(
                          '${p.username} - ${p.timestamp.toLocal()}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
