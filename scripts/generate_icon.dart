// Run from project root: dart run scripts/generate_icon.dart
// Generates assets/icon/app_icon.png (1024x1024) for the expense tracker app.

import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  const int size = 1024;
  // App primary green #2E7D32, white
  final green = img.ColorRgba8(46, 125, 50, 255);
  final white = img.ColorRgba8(255, 255, 255, 255);

  final image = img.Image(width: size, height: size);
  img.fill(image, color: green);

  // White "wallet card" shape: rounded rectangle in center
  final pad = size ~/ 5;
  final left = pad;
  final right = size - pad;
  final top = pad + 60;
  final bottom = size - pad;
  const radius = 100.0;

  img.fillRect(
    image,
    x1: left,
    y1: top,
    x2: right,
    y2: bottom,
    radius: radius,
    color: white,
  );

  // Green dollar sign in center (vertical bar + two horizontal bars for S shape)
  final cx = size ~/ 2;
  final cy = size ~/ 2;
  final barW = 28;
  final barH = 160;
  img.fillRect(
    image,
    x1: cx - barW ~/ 2,
    y1: cy - barH ~/ 2,
    x2: cx + barW ~/ 2,
    y2: cy + barH ~/ 2,
    color: green,
  );
  img.fillRect(
    image,
    x1: cx - 80,
    y1: cy - barH ~/ 2 - 30,
    x2: cx + 80,
    y2: cy - barH ~/ 2 + 40,
    color: green,
  );
  img.fillRect(
    image,
    x1: cx - 80,
    y1: cy + barH ~/ 2 - 40,
    x2: cx + 80,
    y2: cy + barH ~/ 2 + 30,
    color: green,
  );

  final outDir = Directory('assets/icon');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  final file = File('assets/icon/app_icon.png');
  file.writeAsBytesSync(img.encodePng(image));
  print('Generated ${file.path}');
}
