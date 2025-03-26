import 'package:flutter/material.dart';
import 'package:open_finance_app/models/bank_model.dart';
import 'package:open_finance_app/widgets/buttons/bankconnection_button.dart';

/// A widget that displays a scrollable list of banks available for connection.
///
/// This widget creates a ListView containing BankConnection buttons for each bank
/// in the provided list. It handles the selection state of banks and communicates
/// selection changes back to its parent widget.
class BankList extends StatelessWidget {
  /// List of Bank objects to display in the list.
  ///
  /// Each bank in this list will be rendered as a selectable BankConnection widget.
  final List<Bank> banks;
  
  /// The index of the currently selected bank in the [banks] list.
  ///
  /// If null, no bank is currently selected. This value controls which bank
  /// appears visually selected in the UI.
  final int? selectedBankIndex;
  
  /// Callback function that is triggered when a bank is selected.
  ///
  /// The function receives the index of the selected bank in the [banks] list as its parameter.
  /// This allows the parent widget to track which bank is currently selected.
  final Function(int) onBankSelected;

  /// Creates a BankList widget.
  ///
  /// The [banks] parameter is required and specifies the list of banks to display.
  ///
  /// The [onBankSelected] parameter is required and defines the callback that will
  /// be invoked when the user selects a bank from the list.
  ///
  /// The optional [selectedBankIndex] parameter indicates which bank is currently
  /// selected. If null, no bank is visually marked as selected.
  const BankList({
    super.key,
    required this.banks,
    this.selectedBankIndex,
    required this.onBankSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: banks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => BankConnection(
        bankName: banks[index].name,
        bankLogo: banks[index].logo,
        isSelected: selectedBankIndex == index,
        onTap: () => onBankSelected(index),
      ),
    );
  }
}