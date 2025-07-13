import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/core/themes/app_theme.dart';

class ExpansionTileWidget extends StatelessWidget {
  final List<Recall>? recallsList;
  final int i;
  final int? ind;
  const ExpansionTileWidget(
      {Key? key, this.recallsList, required this.i, this.ind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return recallsList!.isEmpty
        ? Container(
            child: Center(child: Text('Safety Recalls Not Found')),
          )
        : Container(
            padding: EdgeInsets.only(bottom: 5),
            child: ExpansionTile(
              backgroundColor: Color(0xFFE6E7E8),
              collapsedBackgroundColor: Color(0xFFE6E7E8),
              title: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      'Safety Recall ' + (ind).toString(),
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppTheme.of(context).primaryColor),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 30,
                    )
                  ],
                ),
              ),
              trailing: const SizedBox.shrink(),
              //leading: ,
              //subtitle: ,
              children: [
                ContentExpansionTile(
                  recall_number: recallsList![i].recall_number,
                  campaign_number: recallsList![i].campaign_number,
                  recall_date: recallsList![i].recall_date,
                  consequence: recallsList![i].consequence,
                  corrective_action: recallsList![i].corrective_action,
                  desc: recallsList![i].desc,
                )
              ],
            ),
          );
  }
}

class ContentExpansionTile extends StatelessWidget {
  final String? campaign_number;
  final String? recall_date;
  final String? recall_number;
  final String? desc;
  final String? corrective_action;
  final String? consequence;

  const ContentExpansionTile(
      {Key? key,
      this.campaign_number,
      this.recall_date,
      this.recall_number,
      this.corrective_action,
      this.consequence,
      this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 250,
                child: Text(
                  'Recall Date :',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Expanded(
                child: Text(
                  recall_date ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                width: 250,
                child: Text(
                  'Campaign Number :',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Expanded(
                child: Text(
                  campaign_number ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                width: 250,
                child: Text(
                  'Recall Number :',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Expanded(
                child: Text(
                  recall_number ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
                text: 'Description : ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
                children: <TextSpan>[
                  TextSpan(
                    text: desc,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  )
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
                text: 'Corrective Action : ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
                children: <TextSpan>[
                  TextSpan(
                    text: corrective_action,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  )
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
                text: 'Consequence : ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
                children: <TextSpan>[
                  TextSpan(
                    text: consequence,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
