import 'package:flutter/material.dart';
import 'package:open_finance_app/models/bank_model.dart';
import 'package:open_finance_app/widgets/buttons/bankconnection_button.dart';

class BankList extends StatelessWidget {
  final List<Bank> banks;
  final int? selectedBankIndex;
  final Function(int) onBankSelected;

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