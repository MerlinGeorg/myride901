import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/blog/blog.dart';
import 'package:myride901/widgets/bloc_provider.dart';

class BlogBloc extends BlocBase {
  StreamController<bool> mainStreamController = StreamController.broadcast();

  Stream<bool> get mainStream => mainStreamController.stream;
  bool hasMore = true;
  bool blogIsFinish = true;
  List<Blog> arrBlog = [];
  @override
  void dispose() {
    mainStreamController.close();
  }
  void getBlogList({BuildContext? context}) {
    if(hasMore) {
      hasMore = false;
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getBlog(offset: arrBlog.length)
          .then((value) {
        (value['blogs'] ?? []).forEach((e) {
          print(e);
          arrBlog.add(Blog.fromJson(e));
        });
        hasMore = arrBlog.length < (value['total_blogs'] ?? 0);
        blogIsFinish = hasMore;
        mainStreamController.sink.add(true);
      }).catchError((onError) {
        print(onError);
      });
    }
  }
}
