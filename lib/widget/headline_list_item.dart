import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Utils.dart';
import '../models/headline.dart';
import 'headline_detail.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post}) : super(key: key);
  final Headlines post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push( // navigate to detail view
          PageRouteBuilder(
            pageBuilder: (context, animation,
                secondaryAnimation) =>  HeadLineDetail(posts: post),
            transitionsBuilder: (context, animation,
                secondaryAnimation, child) =>
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
          ),
        );
      },
      child: Container(
        height: 250,
          color: const Color.fromARGB(255, 70, 70, 70),
          child: Container(
              margin: const EdgeInsets.fromLTRB(16,12,16,12),
              decoration:  const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft:  Radius.circular(10),
                    topRight:  Radius.circular(10),
                    bottomLeft:  Radius.circular(10),
                    bottomRight:  Radius.circular(10)),
              ),
              child: Stack(
                children: <Widget>[
                 ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:post.image==''?Image.asset('assets/no_image_available.jpg',   height: 250, fit: BoxFit.cover) // when image is blank
                        : CachedNetworkImage( // load image and catch
                      imageUrl: post.image,
                      fit: BoxFit.cover,
                      height: 250,
                      placeholder: (context, url) =>
                      const Center(
                          child:  SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                      ),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                        ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container( //shadow from bottom
                        height: 226,
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.bottomCenter,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.2, 0.5, 0.7, 0.9, 0.9, 0.9, 0.9, 0.9],
                            colors: [
                              Colors.black87,
                              Colors.black54,
                              Colors.black12,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft:  Radius.circular(10),
                              bottomRight:  Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: <Widget>[

                          Container(
                            alignment: Alignment.topLeft,
                            child: Text( //  title display
                             post.title,
                             style: const TextStyle(
                               fontSize: 20,
                               fontFamily: 'RobotoSlab',
                               color:  Color.fromARGB(255, 242, 242, 242),
                                 decoration: TextDecoration.none
                             ),
                             textAlign: TextAlign.left,
                              maxLines: 3,
                              ),
                          ),

                          const SizedBox(height: 12),

                            Container( // author and published date display
                              alignment: Alignment.topLeft,
                              child: Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'RobotoSlab-Bold',
                                    color: Color.fromARGB(255, 186, 186, 186),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: post.author,
                                    ),
                                    post.author==''?  const TextSpan(
                                      text: '',
                                    ):  const TextSpan(
                                      text: '   ',
                                    ),
                                    TextSpan(
                                      text: displayFormatDate(),
                                      style:const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'RobotoSlab-Light',
                                        color: Color.fromARGB(255, 186, 186, 186),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 4,
                              ),
                            ),


                        ],),
                      ),
                    ],
                  ),
                  ])
          ),
        ),
    );

  }

  String displayFormatDate(){  // parse date
    return post.publishedAt==''?'':Utils.myFormatDate.format(Utils.timeStamp.parse(post.publishedAt));
  }
}
