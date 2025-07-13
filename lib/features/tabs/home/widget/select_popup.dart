import 'package:flutter/material.dart';
import 'new_invoice_popup.dart';

Future<void> showSelectDialog(BuildContext context) async {
  String? selectedVehicle;
  String? selectedEvent;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Back arrow at the top left
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the Select dialog
                    // showInvoiceDialog(context, () {
                    //   showSelectDialog(context);
                    // }); // Reopen the New Invoice dialog
                  },
                ),
              ),
              Text(
                "Select",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Vehicle"),
                value: selectedVehicle,
                items: ["Car A", "Car B"]
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (val) => setState(() => selectedVehicle = val),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select service event"),
                value: selectedEvent,
                items: ["Brake repair", "Tire change"]
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (val) => setState(() => selectedEvent = val),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text("Cancel"),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (selectedVehicle != null && selectedEvent != null)
                          ? () {
                              // Handle confirm
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[300],
                      ),
                      child: Text("Confirm"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
