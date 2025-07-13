import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';

class CircleOuterLineGradient extends StatelessWidget {
  final String? text;
  final Size? size;
  final _GradientPainter? _painter;
  final double? fontSize;

  CircleOuterLineGradient({
    double? strokeWidth,
    String? text,
    this.size = const Size(60, 60),
    this.fontSize = 15,
  })  : this._painter = _GradientPainter(strokeWidth: strokeWidth!),
        this.text = text;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: Container(
        constraints:
            BoxConstraints(minWidth: size!.width, minHeight: size!.height),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text ?? '',
              style: GoogleFonts.roboto(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleOuterLineGradientAsset extends StatelessWidget {
  final Size size;
  final _GradientPainter _painter;

  CircleOuterLineGradientAsset({
    double? strokeWidth,
    String? text,
    this.size = const Size(60, 60),
  }) : this._painter = _GradientPainter(strokeWidth: strokeWidth!);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: Container(
        constraints:
            BoxConstraints(minWidth: size.width, minHeight: size.height),
        child: Image.asset(
          AssetImages.user_placeholder,
          width: size.width,
          height: size.height,
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double strokeWidth;

  _GradientPainter({double? strokeWidth}) : this.strokeWidth = strokeWidth!;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(size.width / 2));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(size.width / 2 - strokeWidth));
    // apply gradient shader
    _paint.shader = LinearGradient(
            colors: [Color(0xff0C1248), Colors.redAccent],
            begin: Alignment(-1, -1))
        .createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
