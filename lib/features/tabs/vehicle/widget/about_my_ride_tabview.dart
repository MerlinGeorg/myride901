import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/features/tabs/vehicle/vehicle_bloc.dart';
import 'package:myride901/features/tabs/vehicle/widget/add_new_wallet_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutMyRideTabview extends StatefulWidget {
  final List<WalletCard>? list;
  final int? selectedVehicle;
  final VehicleProfileBloc? vehicleProfileBloc;

  const AboutMyRideTabview(
      {Key? key, this.list, this.selectedVehicle, this.vehicleProfileBloc})
      : super(key: key);

  @override
  _AboutMyRideTabviewState createState() => _AboutMyRideTabviewState();
}

class _AboutMyRideTabviewState extends State<AboutMyRideTabview> {
  List<WalletCard>? _list;

  void initState() {
    super.initState();
    if (_list == null) {
      _list = widget.list ?? [];
    }
    print(_list);
    loadWalletCardOrder(widget.selectedVehicle!);
  }

  Future<void> reorderData(int oldIndex, int newIndex) async {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final items = _list!.removeAt(oldIndex);
      _list!.insert(newIndex, items);

      // Get the current order of wallet card IDs
      List<String> currentIndexes =
          (_list ?? []).map((card) => card.id.toString()).toList();

      // Save the new order of wallet card IDs
      AppComponentBase.getInstance()
          .getSharedPreference()
          .saveWalletCardOrder(currentIndexes, widget.selectedVehicle);
    });
  }

  Future<void> loadWalletCardOrder(int vehicleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? order =
        prefs.getStringList('walletCardOrder_' + vehicleId.toString());

    if (order != null) {
      // Reorder the wallet cards based on the loaded order
      List<WalletCard> reorderedWalletCards = [];

      for (String idString in order) {
        int id = int.tryParse(idString) ?? -1;

        // Search for the matching WalletCard
        WalletCard? card;
        for (var walletCard in _list ?? []) {
          if (walletCard.id == id) {
            card = walletCard;
            break;
          }
        }

        // Check if card is not null before adding
        if (card != null) {
          reorderedWalletCards.add(card);
        }
      }

      setState(() {
        _list = reorderedWalletCards;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffC3D7FF).withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(physics: NeverScrollableScrollPhysics(), children: [
        Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      '',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          letterSpacing: 0.5,
                          color: AppTheme.of(context).primaryColor),
                    ),
                  ),
                  /*InkWell(
                    onTap: () {
                      setState(() {
                        isEditable = !isEditable;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppTheme.of(context)
                              .primaryColor
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(5),
                      child: Text('Save'),
                    ),
                  ),*/
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      addProperties();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: AppTheme.of(context)
                              .primaryColor
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        AssetImages.plus,
                        width: 13,
                        height: 1,
                        color: AppTheme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            ReorderableListView.builder(
              onReorder: reorderData,
              padding: const EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (_list ?? []).length,
              itemBuilder: (walletCard, index) {
                final walletCard = _list![index];
                return VerticalStrip(
                  key: ValueKey(walletCard),
                  value: walletCard.value ?? '',
                  title: (walletCard.walletKey ?? '') +
                      (getStr(walletCard)['titleSuffix'] ?? ''),
                  suffix: getStr(walletCard)['suffix'] ?? '',
                  icon: getStr(walletCard)['icon'] ?? '',
                  onDeletePress: () async {
                    if (walletCard.isDefault == 0) {
                      _list = await widget.vehicleProfileBloc!.deleteWallet(
                          context: context, walletCard: walletCard);
                      // Use _list for deletion and call the onDeleteClick callback
                      await loadWalletCardOrder(widget.selectedVehicle!);
                      setState(() {
                        // _list!.removeAt(index);
                      });
                    } else {
                      _list = await widget.vehicleProfileBloc!
                          .deleteWalletDefault(
                              context: context, walletCard: walletCard);
                      // Use _list for deletion and call the onDeleteClick callback
                      await loadWalletCardOrder(widget.selectedVehicle!);
                      setState(() {
                        // _list!.removeAt(index);
                      });
                    }
                  },
                  onEditPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddNewWalletDialog(
                          label: 'Edit Category',
                          onCancel: () => Navigator.pop(context),
                          labelText: walletCard.walletKey ?? '',
                          valueText: walletCard.value ?? '',
                          btnText: 'SAVE',
                          onAdd: (value, label) async {
                            _list = await widget.vehicleProfileBloc!
                                .updateWallet(
                                    context: context,
                                    wallet_key: label,
                                    value: value,
                                    walletCard: walletCard);

                            await loadWalletCardOrder(widget.selectedVehicle!);

                            setState(() {
                              Navigator.pop(context);
                              loadWalletCardOrder(widget.selectedVehicle!);
                            });
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                await addProperties();
              },
              child: SvgPicture.asset(
                AssetImages.add_others,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  addProperties() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddNewWalletDialog(
          label: 'Add New Category',
          onCancel: () => Navigator.pop(context),
          onAdd: (value, label) async {
            _list = await widget.vehicleProfileBloc!.addWallet(
              context: context,
              value: value,
              wallet_key: label,
            );
            await loadWalletCardOrder(widget.selectedVehicle!);

            setState(() {
              Navigator.pop(context);
            });
          },
        );
      },
    );
  }

  Map<String, String> getStr(WalletCard walletCard) {
    Map<String, String> s = {'icon': '', 'suffix': '', 'titleSuffix': ''};
    switch (walletCard.walletKeyId) {
      case 1:
        s = {
          'icon': AssetImages.my_insurance_policy,
          'suffix': '',
          'titleSuffix': ''
        };
        break;
      case 2:
        s = {
          'icon': AssetImages.my_insurance_email,
          'suffix': '',
          'titleSuffix': ''
        };
        break;
      case 3:
        s = {
          'icon': AssetImages.licence_plate,
          'suffix': '',
          'titleSuffix': ''
        };
        break;
      case 4:
        s = {
          'icon': AssetImages.engine_oil,
          'suffix': (walletCard.value ?? '') == '' ? '' : 'W',
          'titleSuffix': ''
        };
        break;
      case 5:
        s = {
          'icon': AssetImages.fuel_tank,
          'suffix': (walletCard.value ?? '') == '' ? '' : '',
          'titleSuffix': '/L'
        };
        break;
      case 6:
        s = {
          'icon': AssetImages.fuel_tank,
          'suffix': (walletCard.value ?? '') == '' ? '' : '',
          'titleSuffix': '/L'
        };
        break;
      case 7:
        s = {'icon': AssetImages.tire_size, 'suffix': '', 'titleSuffix': ''};
        break;
      case 8:
        s = {
          'icon': AssetImages.tire_pressure,
          'suffix': (walletCard.value ?? '') == '' ? '' : 'psi',
          'titleSuffix': ''
        };
        break;
      case 9:
        s = {'icon': AssetImages.brake, 'suffix': '', 'titleSuffix': ''};
        break;
      case 10:
        s = {
          'icon': AssetImages.radia_coolant,
          'suffix': '',
          'titleSuffix': ''
        };
        break;
    }
    return s;
  }
}

class VerticalStrip extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final String suffix;
  final Function? onEditPress;
  final Function? onDeletePress;

  const VerticalStrip(
      {Key? key,
      this.title = '',
      this.value = '',
      this.suffix = '',
      this.icon = '',
      this.onEditPress,
      this.onDeletePress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon == ''
              ? CircleAvatar(
                  minRadius: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      AssetImages.ride_app_logo,
                      width: 16,
                      height: 16,
                    ),
                  ),
                  backgroundColor: AppThemeState().primaryColor,
                )
              : SvgPicture.asset(
                  icon,
                  width: 20,
                  height: 20,
                  color: Color(0xffD03737),
                ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      color: AppTheme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 13),
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    '$value $suffix',
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.roboto(
                        color: AppTheme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Column(
            children: [
              InkWell(
                onTap: () {
                  onEditPress?.call();
                },
                child: Container(
                  height: 19,
                  width: 19,
                  decoration: BoxDecoration(
                      color: AppTheme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.all(6),
                  child: SvgPicture.asset(
                    AssetImages.edit_b,
                    color: AppTheme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  onDeletePress?.call();
                },
                child: Container(
                  height: 19,
                  width: 19,
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset(
                    AssetImages.delete,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
