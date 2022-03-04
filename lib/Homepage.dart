import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:http/http.dart" as http;
import 'package:news_app/bloc/headline_bloc.dart';
import 'package:news_app/view/headline_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
          title: const Text('HEADLINES',
            style: TextStyle(
            fontSize: 29,
            fontFamily: 'RobotoSlab-Bold',
            color: Colors.white,
          ),)),
      body: BlocProvider(
        create: (_) => HeadlineBloc(httpClient: http.Client())..add(PostFetched()),
        child: HeadlineList(),
      ),
    );
  }

}
