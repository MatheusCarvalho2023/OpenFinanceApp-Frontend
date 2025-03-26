import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A widget that displays information about a bank connection with expandable details.
///
/// This widget shows bank connection information in a list tile format with the ability
/// to expand/collapse to show additional account details. It includes a bank icon,
/// name, total balance, and optional drawer content that appears when expanded.
class ConnectionItem extends StatefulWidget {
  /// Icon to represent the financial institution.
  final IconData iconData;
  
  /// Name of the bank or financial institution.
  final String bankName;
  
  /// Total monetary value across all accounts at this institution, formatted as a string.
  final String totalAccountBalance;
  
  /// Optional callback function that is triggered when the main tile is tapped.
  final VoidCallback? onTap;
  
  /// Optional list of widgets to display in the expandable drawer.
  ///
  /// Typically contains additional account information like account numbers,
  /// individual balances, and account-specific controls.
  final List<Widget>? drawerContent;
  
  /// Whether the connection is currently active/enabled.
  ///
  /// This controls the state of the switch toggle if [onSwitchChanged] is provided.
  final bool switchValue;
  
  /// Optional callback function that is triggered when the switch value changes.
  ///
  /// If provided, a switch toggle will be displayed in the trailing area of the list tile.
  final ValueChanged<bool>? onSwitchChanged;

  /// Creates a ConnectionItem widget.
  ///
  /// The [iconData], [bankName], and [totalAccountBalance] parameters are required.
  ///
  /// The [onTap] parameter is optional and specifies the action to take when
  /// the main list tile is tapped.
  ///
  /// The [drawerContent] parameter is optional and contains widgets to display
  /// in the expandable drawer. If null, the expand/collapse button will not be shown.
  ///
  /// The [switchValue] parameter defaults to false if not specified.
  ///
  /// The [onSwitchChanged] parameter is optional and controls whether a switch
  /// toggle is displayed and what happens when its value changes.
  const ConnectionItem({
    super.key,
    required this.iconData,
    required this.bankName,
    required this.totalAccountBalance,
    this.onTap,
    this.drawerContent,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  State<ConnectionItem> createState() => _ConnectionItemState();
}

/// The state class for the ConnectionItem.
///
/// Manages the expansion state and animations for the expandable drawer.
class _ConnectionItemState extends State<ConnectionItem>
    with SingleTickerProviderStateMixin {
  /// Whether the drawer is currently expanded.
  bool _isExpanded = false;
  
  /// Animation controller for the expand/collapse animation.
  late AnimationController _controller;
  
  /// Animation for rotating the expand/collapse icon.
  late Animation<double> _iconTurn;
  
  /// Internal state that tracks the current switch value.
  late bool _switchValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconTurn = Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
    _switchValue = widget.switchValue;
  }

  @override
  void didUpdateWidget(ConnectionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update internal switch value if the widget's value changes
    if (oldWidget.switchValue != widget.switchValue) {
      _switchValue = widget.switchValue;
    }
  }

  @override
  void dispose() {
    // Clean up animation controller when widget is removed
    _controller.dispose();
    super.dispose();
  }

  /// Toggles the expansion state of the drawer.
  ///
  /// Updates the state and animates the icon rotation based on the new expansion state.
  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(widget.iconData),
          title: Text(widget.bankName),
          subtitle: Text(widget.totalAccountBalance),
          onTap: widget.onTap,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Only show the switch if onSwitchChanged is provided
              if (widget.onSwitchChanged != null)
                Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                    // Call the callback with the new value
                    widget.onSwitchChanged!(value);
                  },
                  activeColor: AppColors.primaryColor,
                ),
              // Only show the expand/collapse button if drawer content is provided
              widget.drawerContent != null
                  ? IconButton(
                      icon: RotationTransition(
                        turns: _iconTurn,
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                      onPressed: _toggleExpand,
                    )
                  : Container(),
            ],
          ),
        ),
        // Expandable drawer section
        if (_isExpanded && widget.drawerContent != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: const BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.drawerContent!,
            ),
          ),
      ],
    );
  }
}
