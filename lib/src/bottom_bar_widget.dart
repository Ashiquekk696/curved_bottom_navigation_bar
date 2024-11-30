import 'package:flutter/material.dart';

/// A customizable curved bottom navigation bar widget.
/// 
/// This widget provides a curved bottom navigation bar with animated
/// transitions and customization options.
/// 
/// [CurvedBottomNavigationBar] features:
/// - Animated icons and labels for selected and unselected states.
/// - Curved background for aesthetic appeal.
/// - Customizable colors, fonts, and animations.
///
/// ### Usage Example:
/// ```dart
/// CurvedBottomNavigationBar(
///   selectedIndex: 0,
///   onItemTapped: (index) {
///     // Handle navigation logic here
///   },
///   icons: [Icons.home, Icons.search, Icons.person],
///   labels: ['Home', 'Search', 'Profile'],
///   screens: [HomeScreen(), SearchScreen(), ProfileScreen()],
/// )
/// ```
class CurvedBottomNavigationBar extends StatefulWidget {
  /// The index of the currently selected item.
  final int selectedIndex;

  /// Callback invoked when an item is tapped.
  final ValueChanged<int> onItemTapped;

  /// List of icons to display in the navigation bar.
  final List<IconData> icons;

  /// List of labels corresponding to the icons.
  final List<String> labels;

  /// Background color of the navigation bar.
  final Color backgroundColor;

  /// Height of the navigation bar.
  final double height;

  /// Size of the icons.
  final double iconSize;

  /// Font size of the labels.
  final double labelFontSize;

  /// Duration of the animations.
  final Duration animationDuration;

  /// Text style for selected item labels.
  final TextStyle? selectedItemFontStyle;

  /// Color for the selected item's icon and label.
  final Color selectedItemColor;

  /// Color for unselected item's icons.
  final Color unselectedIconColor;

  /// Text style for unselected item labels.
  final TextStyle? unselectedItemFontStyle;

  /// List of screens corresponding to each navigation item.
  final List<Widget> screens;

  /// Whether to disable animations.
  final bool disableAnimations;

  /// Creates a [CurvedBottomNavigationBar] widget.
  ///
  /// The [selectedIndex], [onItemTapped], [icons], [labels], and [screens] are required.
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
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

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
      body: Stack(
        children: [
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
                    return Positioned(
                      child: GestureDetector(
                        onTap: () {
                          widget.onItemTapped(index);
                          if (!widget.disableAnimations) {
                            _animationController.forward(from: 0);
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Icon(
                              widget.icons[index],
                              size: widget.iconSize,
                              color: widget.selectedIndex == index
                                  ? widget.selectedItemColor
                                  : widget.unselectedIconColor,
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom painter to draw the curved background of the navigation bar.
class CurvedNavBarPainter extends CustomPainter {
  final Color backgroundColor;

  CurvedNavBarPainter(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 10);
    path.quadraticBezierTo(
      size.width / 2, -40, size.width, 10,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
