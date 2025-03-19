import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

class ConnectionItem extends StatefulWidget {
  final IconData iconData;
  final String bankName;
  final String totalAccountBalance;
  final VoidCallback? onTap;
  final List<Widget>? drawerContent;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

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

class _ConnectionItemState extends State<ConnectionItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _iconTurn;
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
    if (oldWidget.switchValue != widget.switchValue) {
      _switchValue = widget.switchValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
