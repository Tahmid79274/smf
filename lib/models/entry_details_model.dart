class EntryDetailsModel{
  String productName,transactionDate,amount;
  bool isDebit;
  EntryDetailsModel({
    required this.productName,
    required this.transactionDate,
    required this.amount,
    required this.isDebit,
});
}