import 'package:flutter/material.dart';

class ConnectionItem extends StatelessWidget {
  final IconData iconData;
  final String bankName;
  final String totalAccountBalance;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ConnectionItem({
    super.key,
    required this.iconData,
    required this.bankName,
    required this.totalAccountBalance,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(iconData),
          title: Text(bankName),
          subtitle: Text(totalAccountBalance),
          trailing: trailing,
          onTap: onTap,
        ),
      ],
    );
  }
}