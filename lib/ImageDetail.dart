import 'dart:ffi';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageDetail extends StatefulWidget {
  const ImageDetail({Key? key, required this.index, required this.photo}) : super(key: key);
  final double index;
  final List<dynamic> photo;
  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  PageController pageController = PageController();
  double ?Page;
  void initState(){
    pageController = PageController(initialPage: widget.index.toInt());
    Page = widget.index;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: Colors.black,
            child: PhotoViewGallery.builder(
              pageController: pageController,
              itemCount: widget.photo.length,
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.photo[index]),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  heroAttributes: PhotoViewHeroAttributes(tag: 'image${widget.index}'),
                );
              },
              onPageChanged: (index){
                setState(() {
                  Page = index.toDouble();
                });
              },
            )
          ),
          Positioned(
            bottom: 50,
            child:DotsIndicator(
              dotsCount: widget.photo.length,
              position: Page!,
              onTap: (position){
                setState(() {
                  Page = position;
                  pageController.animateToPage(
                      position.toInt(),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease
                  );
                });
              },
              decorator: const DotsDecorator(
                  activeColor: Colors.grey,
                  color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
  }
}
