class EntryDetailsModel{
  String entryTitle,entryDetails,transactionDate,amount;
  bool isDebit;
  EntryDetailsModel({
    required this.entryTitle,
    required this.entryDetails,
    required this.transactionDate,
    required this.amount,
    required this.isDebit,
});
}