import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/PayStudyClass.dart';
import '../Class/StudentUserClass.dart';

class Payment_Study extends StatefulWidget {
  final List<StudentUser> data_studentUser;

  Payment_Study({
    Key? key,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  State<Payment_Study> createState() => _Payment_StudyState();
}

class _Payment_StudyState extends State<Payment_Study> {
  bool isLoading = false;
  List<PayStudy> _dataPayStudy = [];
  List<ReExamStudyClass> _dataReExam = [];
  List<CreditPayClass> _dataCredit = [];
  List<OtherPayClass> _dataOther = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse('http://192.168.3.87/usea/api/apidata.php?action=payment'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      var response1 = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_payment_re_exam_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      var response2 = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_payment_credit_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      var response3 = await http.post(
        Uri.parse(
            'http://192.168.3.87/usea/api/apidata.php?action=other_payment'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['pay_study_data'] is List) {
          List<dynamic> payStudyData = data['pay_study_data'];
          List<PayStudy> payStudies = [];

          payStudyData.forEach((yearData) {
            if (yearData is Map<String, dynamic>) {
              List<dynamic> paymentList = yearData['invoices'];
              List<Payment> payments = [];

              paymentList.forEach((paymentData) {
                if (paymentData is Map<String, dynamic>) {
                  var payment = Payment.fromJson(paymentData);
                  payments.add(payment);
                }
              });

              var payStudy = PayStudy(
                yearName: yearData['year'].toString(),
                moneyPay: yearData['finalprice'].toString(),
                payments: payments,
              );

              payStudies.add(payStudy);
            }
          });

          setState(() {
            _dataPayStudy = payStudies;
            isLoading = false;
          });
        } else {
          print('Response Body: ${response.body}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Response Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
      if (response1.statusCode == 200 &&
          response2.statusCode == 200 &&
          response3.statusCode == 200) {
        var data1 = jsonDecode(response1.body);
        var data2 = jsonDecode(response2.body);
        var data3 = jsonDecode(response3.body);
        setState(() {
          _dataReExam = List<ReExamStudyClass>.from(data1['pay_re_exam_data']
              .map((data1) => ReExamStudyClass.fromJson(data1)));
          _dataCredit = List<CreditPayClass>.from(data2['pay_credit_data']
              .map((data2) => CreditPayClass.fromJson(data2)));
          _dataOther = List<OtherPayClass>.from(data3['pay_other_data']
              .map((data3) => OtherPayClass.fromJson(data3)));

          isLoading = false;
        });
      } else {
        print('Response Body: ${response1.body}');

        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildPaymentDetailsDialog(PayStudy payStudy) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              Text(payStudy.yearName),
              DataTable(
                columnSpacing: 0,
                columns: [
                  DataColumn(
                    label: Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text('Date')),
                  ),
                  DataColumn(
                    label: Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text('Invoice')),
                  ),
                  DataColumn(
                    label: Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text('MPd')),
                  ),
                  DataColumn(
                    label: Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text('MR')),
                  ),
                ],
                rows: payStudy.payments.map((payment) {
                  return DataRow(cells: [
                    DataCell(Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text(payment.pdate))),
                    DataCell(Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text(payment.invoiceNum))),
                    DataCell(Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text(payment.moneyPaid))),
                    DataCell(Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text(payment.moneyRem))),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          children: [
            _dataPayStudy.isEmpty
                ? Center(
                    child: Text('No Study Payment Data'),
                  )
                : buildStudyPay(),
            _dataReExam.isEmpty
                ? Center(
                    child: Text('No Re-Exam Payment Data'),
                  )
                : buildReExam(),
            _dataCredit.isEmpty
                ? Center(
                    child: Text('No Credit Payment Data'),
                  )
                : buildCredit(),
            _dataOther.isEmpty
                ? Center(
                    child: Text('No Other Payment Data'),
                  )
                : buildOther(),
          ],
        ),
      ),
    );
  }

  Widget buildStudyPay() {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Text('Payment Study'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 80, child: Text('Year Name')),
              Container(width: 80, child: Text('Money Pay')),
              Container(width: 80, child: Text('Money Paid')),
              Container(
                  width: 80,
                  child: Text(
                    'Money Remain',
                  )),
            ],
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _dataPayStudy.length,
            itemBuilder: (context, index) {
              PayStudy payStudy = _dataPayStudy[index];

              double totalPaid = payStudy.payments.fold(
                0.0,
                (sum, payment) =>
                    sum + (double.tryParse(payment.moneyPaid) ?? 0.0),
              );

              double totalRem = payStudy.payments.isNotEmpty
                  ? double.tryParse(payStudy.payments.last.moneyRem) ?? 0.0
                  : 0.0;

              return Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 80,
                      child: Text('Year ${payStudy.yearName}'),
                    ),
                    Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: Text(payStudy.moneyPay),
                    ),
                    Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: Text(totalPaid.toString()),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildPaymentDetailsDialog(payStudy);
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: Text(
                              totalRem.toString(),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            height: 1,
                            width: 10,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildReExam() {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Text('Re-Exam Payment'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  child: Text('Date'),
                ),
                Container(
                  width: 65,
                  child: Text('Invoice'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Pay'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Paid'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Remain'),
                )
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _dataReExam.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          child: Text(_dataReExam[index].re_pdate),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataReExam[index].re_invoice),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataReExam[index].re_money_pay),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataReExam[index].re_money_paid),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataReExam[index].re_money_rem),
                        )
                      ],
                    ),
                  );
                })
          ],
        ));
  }

  Widget buildCredit() {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Text('Credit Payment'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  child: Text('Date'),
                ),
                Container(
                  width: 65,
                  child: Text('Invoice'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Pay'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Paid'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Remain'),
                )
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _dataCredit.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          child: Text(_dataCredit[index].c_pdate),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataCredit[index].c_invoice),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataCredit[index].c_money_pay),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataCredit[index].c_money_paid),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataCredit[index].c_money_rem),
                        )
                      ],
                    ),
                  );
                })
          ],
        ));
  }

  Widget buildOther() {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Text('Other Payment'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  child: Text('Date'),
                ),
                Container(
                  width: 65,
                  child: Text('Invoice'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Pay'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Paid'),
                ),
                Container(
                  width: 65,
                  child: Text('Money Remain'),
                )
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _dataOther.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          child: Text(_dataOther[index].o_pdate),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataOther[index].o_invoice),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataOther[index].o_money_pay),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataOther[index].o_money_paid),
                        ),
                        Container(
                          width: 65,
                          child: Text(_dataOther[index].o_money_rem),
                        )
                      ],
                    ),
                  );
                })
          ],
        ));
  }
}
