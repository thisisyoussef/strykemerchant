class Receipt {
  String businessName;
  String id = "";
  String payer;
  String payee;
  double amount;
  String description;
  double tip;
  String transactionNumber;
  String transaction;
  String date;
  double totalAmount;
  String payerSortCode;
  String payerAccountNumber;
  String payeeSortCode;
  String payeeAccountNumber;
  String createdAt;
  String updatedAt;
  int v;
  Receipt({
    String BUSINESSNAME,
    String ID,
    PAYER,
    PAYEE,
    AMOUNT,
    DESCRIPTION,
    TIP,
    TRANSACTIONNUMBER,
    TRANSACTION,
    DATE,
    TOTALAMOUNT,
    PAYERSORTCODE,
    PAYERACCOUNTNUMBER,
    PAYEESORTCODE,
    PAYEEACCOUNTNUMBER,
    CREATEDAT,
    UPDATEDAT,
    V,
  }) {
    businessName = BUSINESSNAME;
    id = ID;
    payer = PAYER;
    payee = PAYEE;
    amount = AMOUNT;
    description = DESCRIPTION;
    tip = TIP;
    transactionNumber = TRANSACTIONNUMBER;
    transaction = TRANSACTION;
    date = DATE;
    totalAmount = TOTALAMOUNT;
    payerSortCode = PAYERSORTCODE;
    payerAccountNumber = PAYERACCOUNTNUMBER;
    payeeSortCode = PAYEESORTCODE;
    payeeAccountNumber = PAYEEACCOUNTNUMBER;
    createdAt = CREATEDAT;
    updatedAt = UPDATEDAT;
    v = V;
  }
}
