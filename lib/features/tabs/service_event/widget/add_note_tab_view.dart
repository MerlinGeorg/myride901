import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';

class AddNoteTabView extends StatefulWidget {
  final TextEditingController? textEditingController;
  final bool value;

  const AddNoteTabView({
    Key? key,
    @required this.textEditingController,
    this.value = false,
  }) : super(key: key);

  @override
  _AddNoteTabViewState createState() => _AddNoteTabViewState();
}

class _AddNoteTabViewState extends State<AddNoteTabView>
    with AutomaticKeepAliveClientMixin<AddNoteTabView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(AssetImages.ellipse_red),
              SizedBox(
                width: 15,
              ),
              Text(
                StringConstants.note,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    color: AppTheme.of(context).primaryColor),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: TextFormField(
              maxLines: 1000,
              cursorColor: Colors.black,
              controller: widget.textEditingController,
              textCapitalization: TextCapitalization.sentences,
              readOnly: widget.value,
              onFieldSubmitted: (str) {},
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppTheme.of(context).primaryColor, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(208, 208, 208, 1), width: 1.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(208, 208, 208, 1), width: 1.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  //  filled: true,
                  hintStyle: GoogleFonts.roboto(
                      color: Color(0xff121212).withOpacity(0.2)),
                  hintText: StringConstants.add_notes_about,
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 10.0),
                  fillColor: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
