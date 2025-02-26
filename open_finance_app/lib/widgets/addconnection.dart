import 'package:flutter/material.dart';

class AddConnectionButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddConnectionButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Padding(
        padding:  EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
             SizedBox(width: 16),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                     Icon(Icons.add_circle),
                     SizedBox(width: 12), // Space between icon and text
                    Text(
                      "Add New Connection", 
                    ),
                  ],
                ),
              ),
            ),
             SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

