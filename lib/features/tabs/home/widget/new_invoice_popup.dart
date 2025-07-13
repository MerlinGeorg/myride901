import 'package:flutter/material.dart';
import 'select_popup.dart';

Future<void> showInvoiceDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Text(
              "You have a new invoice!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            // Invoice preview
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.receipt_long, size: 48, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {}, // Implement preview logic if needed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: StadiumBorder(),
                  ),
                  child: Text("Preview"),
                ),
                SizedBox(height: 4),
                Text("IMG_6543_8099", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Would you like to add it to your service timeline?",
              textAlign: TextAlign.center,
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
                    child: Text("Cancel and Delete"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                  //    Navigator.of(context).pop();
                      showSelectDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                    ),
                    child: Text("View & Add"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
