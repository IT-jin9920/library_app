class PrintStudentRecordsDetails {
  final String? startDate;
  final String? endDate;
  final String? fee;
  final String? feeWord;
  final String? payment_mode;
  final String? createdAt;

  PrintStudentRecordsDetails(
       {
    this.startDate,
    this.endDate,
    this.fee,
         this.feeWord,
         this.payment_mode,
    this.createdAt,
  });

  factory PrintStudentRecordsDetails.fromJson(Map<String, dynamic> json) {
    return PrintStudentRecordsDetails(
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      fee: json['fee'] as String?,
      feeWord: json['fees_in_word'] as String?,
      payment_mode: json['payment_mode'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
      'fee': fee,
      'fees_in_word': feeWord,
      'payment_mode': payment_mode,
      'created_at': createdAt,
    };
  }
}
