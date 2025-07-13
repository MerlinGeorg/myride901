import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';

class ProviderListView extends StatelessWidget {
  final List<VehicleProvider>? list;
  final VehicleProvider? vehicleProvider;
  final Function? btnEditClicked;
  final Function? btnDeleteClicked;

  const ProviderListView(
      {Key? key,
      this.list,
      this.vehicleProvider,
      this.btnDeleteClicked,
      this.btnEditClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    list?.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (list ?? []).length,
            itemBuilder: (_, index) {
              return ProviderListItem(
                name: (list ?? [])[index].name ?? '',
                email: (list ?? [])[index].email ?? '',
                phone: (list ?? [])[index].phone ?? '',
                btnDeleteClicked: () {
                  btnDeleteClicked?.call(index);
                },
                btnEditClicked: () {
                  btnEditClicked?.call(index);
                },
              );
            }),
        if ((list ?? []).length != 0)
          SizedBox(
            height: 30,
          ),
      ],
    );
  }
}

class ProviderListItem extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final Function? btnEditClicked;
  final Function? btnDeleteClicked;

  const ProviderListItem(
      {Key? key,
      this.name,
      this.email,
      this.phone,
      this.btnEditClicked,
      this.btnDeleteClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 70,
                height: 70,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(1, 3)),
                  ],
                  border: Border.all(
                    width: 2,
                    color: Color(0xffEEEEEE),
                    style: BorderStyle.solid,
                  ),
                  color: Color(0xFFCCD4EB).withOpacity(0.2),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AssetImages.service,
                    width: 25,
                    height: 25,
                  ),
                )),
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
                    name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff121212)),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    email ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xff121212).withOpacity(0.6)),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    phone ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xffAAAAAA)),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              height: 70,
              child: Center(
                child: InkWell(
                  onTap: () {
                    btnEditClicked!();
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color:
                            AppTheme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      AssetImages.edit_b,
                      width: 13,
                      height: 1,
                      color: AppTheme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              height: 70,
              child: Center(
                child: InkWell(
                  onTap: () {
                    btnDeleteClicked!();
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.all(6),
                    child: SvgPicture.asset(
                      AssetImages.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
