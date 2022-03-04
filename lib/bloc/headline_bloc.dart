import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/DBHelper.dart';
import 'dart:async';
import 'dart:convert';
import 'package:news_app/models/headline.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import '../Utils.dart';
import 'package:connectivity/connectivity.dart';

part 'headline_event.dart';
part 'headline_state.dart';

const _postLimit = 20;  // limit if use pagination
const throttleDuration = Duration(milliseconds: 100);  // duration for fetch data
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HeadlineBloc extends Bloc<HeadlineEvent, HeadlineState> {
  HeadlineBloc({required this.httpClient}) : super(const HeadlineState()) {
    on<PostFetched>(
      _onPostFetched,  // fetch data from server
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  // fetch successfully and store to list state
  Future<void> _onPostFetched(
      PostFetched event,
      Emitter<HeadlineState> emit,
      ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }
      final posts = await _fetchPosts(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
        state.copyWith(
          status: PostStatus.success,
          posts: List.of(state.posts)..addAll(posts),
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  // API calling
  Future<List<Headlines>> _fetchPosts([int startIndex = 0]) async {
    var connectivityResult = await (Connectivity().checkConnectivity()); // check network connectivity
    if (connectivityResult == ConnectivityResult.none) {  // not connected to network
      return DBHelper().getHeadlines(); // fetch from local
    }else{
      /* final response = await httpClient.get(
      Uri.https(
        Utils.url,
        '/v2/everything?q=tesla&from=2022-02-04&sortBy=publishedAt&apikey=0d2cf95abd2245188300c1818b5f7df1',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );*/ // for pagination
      final response = await http.get(Uri.parse(Utils.url+"/v2/everything?q=apple&from=2022-03-03&to=2022-03-03&sortBy=popularity&apiKey="+Utils.apiKey));

      if (response.statusCode == 200) {  // get result without error
        var bodyS = json.decode(response.body);
        if(bodyS['status']=='ok'){
          final body = bodyS['articles'] as List;
          return body.map((dynamic json) {
            Headlines headlines = Headlines(
              title:  json['title']==null?'':  json['title'] as String,
              image: json['urlToImage']==null?'': json['urlToImage'] as String,
              author: json['author']==null?'': json['author'] as String,
              publishedAt: json['publishedAt']==null?'': json['publishedAt'] as String,
              description: json['description']==null?'': json['description'] as String,
            );
            DBHelper().save(headlines);
            return headlines;
          }).toList();
        }

      }
      throw Exception('error fetching Headline');
    }
  }
}
