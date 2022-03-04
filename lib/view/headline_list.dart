import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/DBHelper.dart';
import 'package:news_app/bloc/headline_bloc.dart';

import '../models/headline.dart';
import '../widget/bottom_layer.dart';
import '../widget/headline_list_item.dart';

class HeadlineList extends StatefulWidget {
  @override
  _HeadlineListState createState() => _HeadlineListState();
}

class _HeadlineListState extends State<HeadlineList> {
  final _scrollController = ScrollController();
  List<Headlines> posts = [];

  @override
  void initState() {
    super.initState();
    getDataFromLocal();
    _scrollController.addListener(_onScroll);
  }

  getDataFromLocal() async{
    List<Headlines> postsHead = await DBHelper().getHeadlines();
    setState(() {
      posts = postsHead;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 70, 70, 70),
      padding: const EdgeInsets.only(top: 12,bottom: 12),
      child: BlocBuilder<HeadlineBloc, HeadlineState>(
        builder: (context, state) {
          switch (state.status) {
            case PostStatus.failure:
              //return const Center(child: Text('failed to fetch posts'));
              return ListView.builder( // local list when not connected with network
                itemBuilder: (BuildContext context, int index) {
                  return  PostListItem(post: posts[index]);
                  },
                itemCount: posts.length,
              );
            case PostStatus.success:
              if (state.posts.isEmpty) {
                return const Center(child: Text('no posts'));
              }
              return ListView.builder(  // list get from server
                itemBuilder: (BuildContext context, int index) {
                /*  return index >= state.posts.length
                      ? BottomLoader() // for pagination
                      : PostListItem(post: state.posts[index]);*/
                  return  PostListItem(post: state.posts[index]);
                },
                itemCount: state.posts.length,
                /*itemCount: state.hasReachedMax  // for pagination
                    ? state.posts.length
                    : state.posts.length + 1,*/
               // controller: _scrollController,
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<HeadlineBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
