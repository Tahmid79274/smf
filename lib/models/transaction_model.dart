import 'entry_details_model.dart';

class TransactionModel{
  String key,transactionName,income,expense,remainingBalance;
  List<EntryDetailsModel> entries;
  TransactionModel({
   required this.key,
   required this.transactionName,
   required this.income,
   required this.expense,
   required this.remainingBalance,
   required this.entries,
});
}