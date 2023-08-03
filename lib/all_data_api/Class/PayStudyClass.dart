class PayStudy {
  final String yearName;
  final String moneyPay;

  final List<Payment> payments;

  PayStudy({
    required this.yearName,
    required this.moneyPay,
    required this.payments,
  });

  factory PayStudy.fromJson(Map<String, dynamic> json) {
    List<Payment> payments =
        List<Payment>.from(json['invoices'].map((x) => Payment.fromJson(x)));
    return PayStudy(
      yearName: json['year'].toString(),
      moneyPay: json['finalprice'].toString(),
      payments: payments,
    );
  }
}

class Payment {
  final String invoiceNum;
  final String pdate;
  final String moneyPaid;
  final String moneyRem;

  Payment({
    required this.invoiceNum,
    required this.pdate,
    required this.moneyPaid,
    required this.moneyRem,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      invoiceNum: json['invoice_num'] ?? '',
      pdate: json['pdate'] ?? '',
      moneyPaid: json['money_paid'],
      moneyRem: json['money_rem'] ?? '',
    );
  }
}

// ReExam Study Payment
class ReExamStudyClass {
  final String re_invoice;
  final String re_pdate;
  final String re_money_pay;
  final String re_money_paid;
  final String re_money_rem;

  ReExamStudyClass(
      {required this.re_pdate,
      required this.re_invoice,
      required this.re_money_pay,
      required this.re_money_paid,
      required this.re_money_rem});

  factory ReExamStudyClass.fromJson(Map<String, dynamic> json) {
    return ReExamStudyClass(
      re_pdate: json['re_pdate'],
      re_invoice: json['re_invoice'],
      re_money_pay: json['re_money_pay'],
      re_money_paid: json['re_money_paid'],
      re_money_rem: json['re_money_rem'],
    );
  }
}

// Credit Payment
class CreditPayClass {
  final String c_invoice;
  final String c_pdate;
  final String c_money_pay;
  final String c_money_paid;
  final String c_money_rem;

  CreditPayClass(
      {required this.c_pdate,
      required this.c_invoice,
      required this.c_money_pay,
      required this.c_money_paid,
      required this.c_money_rem});

  factory CreditPayClass.fromJson(Map<String, dynamic> json) {
    return CreditPayClass(
      c_pdate: json['c_pdate'],
      c_invoice: json['c_invoice'],
      c_money_pay: json['c_money_pay'],
      c_money_paid: json['c_money_paid'],
      c_money_rem: json['c_money_rem'],
    );
  }
}

// Other Payment
class OtherPayClass {
  final String o_invoice;
  final String o_pdate;
  final String o_money_pay;
  final String o_money_paid;
  final String o_money_rem;

  OtherPayClass(
      {required this.o_pdate,
      required this.o_invoice,
      required this.o_money_pay,
      required this.o_money_paid,
      required this.o_money_rem});

  factory OtherPayClass.fromJson(Map<String, dynamic> json) {
    return OtherPayClass(
      o_pdate: json['o_pdate'],
      o_invoice: json['o_invoice'],
      o_money_pay: json['o_money_pay'],
      o_money_paid: json['o_money_paid'],
      o_money_rem: json['o_money_rem'],
    );
  }
}
