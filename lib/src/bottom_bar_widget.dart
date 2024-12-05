import 'package:flutter/material.dart';

/// A custom bottom navigation bar with a curved design, animations, and dynamic icon selection.
/// 
/// This widget allows for a curved bottom navigation bar with custom icons, labels, animations,
/// and background color. It also supports customizing the size of icons, the font size of labels,
/// and the selection animation duration.
///
/// [CurvedBottomNavigationBar] requires:
/// - [selectedIndex] - The index of the currently selected item.
/// - [onItemTapped] - A callback function to handle item selection.
/// - [icons] - A list of icons to be displayed in the navigation bar.
/// - [labels] - A list of labels corresponding to the icons.
/// - [screens] - A list of screens that correspond to each icon in the navigation bar.
///
/// Optional parameters:
/// - [backgroundColor] - The background color of the navigation bar.
/// - [height] - The height of the bottom navigation bar.
/// - [iconSize] - The size of the icons.
/// - [labelFontSize] - The font size for the labels.
/// - [animationDuration] - The duration for the animations.
/// - [selectedItemFontStyle] - The font style for the selected item label.
/// - [selectedItemColor] - The color of the selected item icon and label.
/// - [unselectedIconColor] - The color of the unselected item icons.
/// - [unselectedItemFontStyle] - The font style for the unselected item label.
/// - [disableAnimations] - Whether to disable animations for item selection.
class CurvedBottomNavigationBar extends StatefulWidget {
  /// Index of the currently selected item.
  final int selectedIndex;

  /// Callback function triggered when an item is tapped.
  final ValueChanged<int> onItemTapped;

  /// List of icons displayed in the navigation bar.
  final List<IconData> icons;

  /// List of labels corresponding to each icon.
  final List<String> labels;

  /// Background color of the navigation bar.
  final Color backgroundColor;

  /// Height of the navigation bar.
  final double height;

  /// Size of the icons in the navigation bar.
  final double iconSize;

  /// Font size for the labels.
  final double labelFontSize;

  /// Duration for the animations.
  final Duration animationDuration;

  /// Font style for the selected item's label.
  final TextStyle? selectedItemFontStyle;

  /// Color for the selected item's icon and label.
  final Color selectedItemColor;

  /// Color for the unselected icons.
  final Color unselectedIconColor;

  /// Font style for the unselected item's label.
  final TextStyle? unselectedItemFontStyle;

  /// List of screens associated with each navigation bar item.
  final List<Widget> screens;

  /// Flag to disable animations.
  final bool disableAnimations;

  const CurvedBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.icons,
    required this.labels,
    required this.screens,
    this.backgroundColor = Colors.blue,
    this.height = 70,
    this.iconSize = 30,
    this.labelFontSize = 12,
    this.animationDuration = const Duration(milliseconds: 300),
    this.selectedItemFontStyle,
    this.selectedItemColor = Colors.white,
    this.unselectedIconColor = Colors.white70,
    this.unselectedItemFontStyle,
    this.disableAnimations = false,
  });

  @override
  _CurvedBottomNavigationBarState createState() =>
      _CurvedBottomNavigationBarState();
}

class _CurvedBottomNavigationBarState extends State<CurvedBottomNavigationBar>
    with TickerProviderStateMixin {
  /// Animation controller for managing animations.
  late AnimationController _animationController;

  /// Animation for shaking the icon.
  late Animation<double> _shakeAnimation;

  /// Animation for scaling the icon.
  late Animation<double> _scaleAnimation;

  /// Animation for transitioning the icon color.
  late Animation<Color?> _colorAnimation;

  /// Tracks whether an item is tapped.
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: widget.unselectedIconColor,
      end: widget.selectedItemColor,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// Displays the currently selected screen.
            widget.screens[widget.selectedIndex],
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                height: widget.height,
                child: CustomPaint(
                  painter: CurvedNavBarPainter(widget.backgroundColor),
                  child: Stack(
                    children: List.generate(widget.icons.length, (index) {
                      /// Calculates the horizontal position of each icon.
                      double dx = (index + 0.5) *
                          (MediaQuery.of(context).size.width /
                              widget.icons.length);

                      /// Calculates the vertical position of each icon based on the curve.
                      double dy = _getYForPosition(
                          dx, MediaQuery.of(context).size.width);

                      return Positioned(
                        left: dx - 15,
                        top: dy - 30,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                /// Handles item tap and triggers animations if enabled.
                                widget.onItemTapped(index);
                                isTapped = true;
                                if (!widget.disableAnimations) {
                                  _animationController.forward(from: 0);
                                }
                              },
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      widget.disableAnimations
                                          ? 0
                                          : _shakeAnimation.value *
                                              (widget.selectedIndex == index
                                                  ? 1
                                                  : 0),
                                      0,
                                    ),
                                    child: Transform.scale(
                                      scale: widget.selectedIndex == index
                                          ? (widget.disableAnimations
                                              ? 1
                                              : _scaleAnimation.value)
                                          : 1,
                                      child: Icon(
                                        widget.icons[index],
                                        size: widget.iconSize,
                                        color: widget.disableAnimations
                                            ? (widget.selectedIndex == index
                                                ? widget.selectedItemColor
                                                : widget.unselectedIconColor)
                                            : (widget.selectedIndex == index
                                                ? _colorAnimation.value
                                                : widget.unselectedIconColor),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (widget.selectedIndex == index)
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Text(
                                    widget.labels[index],
                                    style: widget.disableAnimations
                                        ? widget.selectedItemFontStyle?.copyWith(
                                              color: widget.selectedItemColor,
                                            ) ??
                                            const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white)
                                        : widget.selectedItemFontStyle?.copyWith(
                                              color: _colorAnimation.value,
                                            ) ??
                                            TextStyle(
                                              fontSize: widget.labelFontSize,
                                              color: _colorAnimation.value,
                                            ),
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calculates the vertical position (Y-coordinate) of an icon on the curved navigation bar.
  /// The `x` parameter is the horizontal position of the icon, and `width` is the total width of the navigation bar.
  /// 
  /// The function uses a quadratic bezier curve to create the "curved" effect for the icons.
  double _getYForPosition(double x, double width) {
    double t = x / width;
    double y =
        -25 * (4 * t * (1 - t)); // Adjust this for the desired curve effect
    return y + 50; // Shift the curve up so the icons are positioned properly
  }
}

/// A custom painter for drawing the curved background of the bottom navigation bar.
class CurvedNavBarPainter extends CustomPainter {
  /// Background color of the curved navigation bar.
  final Color backgroundColor;

  CurvedNavBarPainter(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 10); // Start at the top-left corner

    // Adjusted control point for a more curved effect
    path.quadraticBezierTo(
        (size.width / 2), -40, size.width, 10); // Lower curve

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 
