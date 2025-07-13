import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/blog/blog.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/routes.dart';
import 'package:myride901/widgets/customNetwork.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class BlocTabView extends StatelessWidget {
  final List<Blog>? list;
  final Function? onLoadMorePress;
  final bool? blogIsFinish;
  const BlocTabView(
      {Key? key, this.list, this.onLoadMorePress, this.blogIsFinish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (list ?? []).length,
            itemBuilder: (_, index) {
              return BlocListItem(
                title: (list ?? [])[index].title ?? '',
                date: (list ?? [])[index].date ?? '',
                pic: (list ?? [])[index].image ?? '',
                url: (list ?? [])[index].url ?? '',
                id: (list ?? [])[index].id ?? 0,
              );
            }),
        if ((list ?? []).length != 0 && (blogIsFinish ?? false))
          SizedBox(
            height: 30,
          ),
        if ((list ?? []).length != 0 && (blogIsFinish ?? false))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: BlueButton(
              onPress: () {
                onLoadMorePress?.call();
              },
              text: 'LOAD MORE',
            ),
          )
      ],
    );
  }
}

class BlocListItem extends StatelessWidget {
  final String? pic;
  final String? title;
  final String? date;
  final String? url;
  final int? id;

  const BlocListItem(
      {Key? key, this.pic, this.id, this.title, this.date, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteName.webViewDisplayPage,
              arguments:
                  ItemArgument(data: {'url': url, 'title': 'Blog', 'id': 1}));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetwork(
              height: 70,
              width: 70,
              fit: BoxFit.fill,
              image: pic ?? '',
              radius: 10,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff121212)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    date ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xff121212).withOpacity(0.6)),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}
