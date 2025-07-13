import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/not_used/blog/blog_bloc.dart';
import 'package:myride901/features/tabs/home/widget/blog_tab_view.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final _blogsBloc = BlogBloc();
  AppThemeState _appTheme = AppThemeState();
  int count = 5;

  @override
  void initState() {
    super.initState();
    _blogsBloc.getBlogList(context: context);
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _blogsBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: _appTheme.primaryColor,
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetImages.left_arrow),
                    )),
                title: Text(
                  'Blog',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              body: BlocProvider<BlogBloc>(
                  bloc: _blogsBloc,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _blogsBloc.arrBlog.length,
                              itemBuilder: (_, index) {
                                return BlocListItem(
                                  title: _blogsBloc.arrBlog[index].title ?? '',
                                  date: _blogsBloc.arrBlog[index].date ?? '',
                                  pic: _blogsBloc.arrBlog[index].image ?? '',
                                  url: _blogsBloc.arrBlog[index].url ?? '',
                                  id: _blogsBloc.arrBlog[index].id ?? 0,
                                );
                              }),
                          if (_blogsBloc.arrBlog.length != 0 &&
                              _blogsBloc.blogIsFinish)
                            SizedBox(
                              height: 30,
                            ),
                          if (_blogsBloc.arrBlog.length != 0 &&
                              _blogsBloc.blogIsFinish)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: BlueButton(
                                onPress: () {
                                  _blogsBloc.getBlogList(context: context);
                                },
                                text: 'LOAD MORE',
                              ),
                            )
                        ],
                      ))),
            );
          }),
    );
  }
}
