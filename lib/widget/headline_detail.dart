import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Utils.dart';
import '../models/headline.dart';

class HeadLineDetail extends StatelessWidget {
  const HeadLineDetail({Key? key, required this.posts}) : super(key: key);
  final Headlines posts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
        color: const Color.fromARGB(255, 70, 70, 70),
        child:  Stack(
              children: <Widget>[
               ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:posts.image==''?Image.asset('assets/no_image_available.jpg',  height: double.infinity, // when image is blank
                        width: double.infinity, fit: BoxFit.cover)
                      : CachedNetworkImage(  // load image and catch
                    imageUrl: posts.image,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: (context, url) =>
                    const Center(
                        child:  SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),  // loader indicator
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
                    Container(  // shadow from bottom
                      padding: const EdgeInsets.all(24),
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
                          child: Text(  // title display
                           posts.title,
                           style: const TextStyle(
                             fontSize: 29,
                             fontFamily: 'RobotoSlab',
                             color:  Color.fromARGB(255, 242, 242, 242),
                               decoration: TextDecoration.none
                           ),
                           textAlign: TextAlign.left,
                            ),
                        ),

                        const SizedBox(height: 64),

                          SizedBox( // author and published date display
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                                Flexible(
                                  child: Text(
                                    posts.author,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'RobotoSlab-Bold',
                                      color:  Color.fromARGB(255, 242, 242, 242),
                                        decoration: TextDecoration.none
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                                Text(
                                  displayFormatDate(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'RobotoSlab-Bold',
                                    color:  Color.fromARGB(255, 242, 242, 242),
                                      decoration: TextDecoration.none
                                  ),

                                  textAlign: TextAlign.right,
                                ),


                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text( // description display
                            posts.description,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'RobotoSlab',
                              color: Color.fromARGB(255, 186, 186, 186),
                                decoration: TextDecoration.none
                            ),
                            textAlign: TextAlign.left,
                          ),
                      ],),
                    ),
                  ],
                ),

                GestureDetector( // back arrow for navigate to back screen
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 42,
                    width: 42,
                    margin: const EdgeInsets.fromLTRB(10,25,10,10),
                    decoration:  const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.only(
                          topLeft:  Radius.circular(50),
                          topRight:  Radius.circular(50),
                          bottomLeft:  Radius.circular(50),
                          bottomRight:  Radius.circular(50)),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),

                ])

      );

  }

  String displayFormatDate(){ // parse date
    return posts.publishedAt==''?'':Utils.myFormatDate.format(Utils.timeStamp.parse(posts.publishedAt));
  }

}
