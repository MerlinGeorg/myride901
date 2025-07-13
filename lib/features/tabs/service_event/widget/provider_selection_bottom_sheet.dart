import 'package:flutter/material.dart';
import 'package:myride901/models/service_provider/service_provider.dart';
import 'package:myride901/features/tabs/service_event/widget/bottom_sheet_list_item.dart';

class ProviderSelectionBottomSheet extends StatelessWidget {
  final List<VehicleProvider> providers;
  final Function(VehicleProvider) onTap;

  ProviderSelectionBottomSheet({required this.providers, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: (providers.length == 0)
                      ? Center(
                          child: Text(
                            'You do not have any contacts yet',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xff121212).withOpacity(0.4),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: providers.length,
                          itemBuilder: (context, index) {
                            return BottomListItem(
                              onTap: () {
                                onTap(providers[index]);
                                Navigator.pop(context);
                              },
                              name: providers[index].name ?? '',
                            );
                          },
                        ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
