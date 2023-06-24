import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'payment_grids_form_value.dart';

class PaymentGridItem extends StatelessWidget {
  const PaymentGridItem({super.key, required this.value});

  final PaymentGridsFormValue value;

  static const double kGridWidth = 120.0;

  @override
  Widget build(BuildContext context) {
    final PaymentGridsFormValue value = this.value;
    final PaymentEntity? payment = switch (value) {
      PaymentGridsCreateFormValue() => null,
      PaymentGridsModifyFormValue() => value.data,
    };
    final ({DateTime createdAt, double price}) record = switch (value) {
      PaymentGridsCreateFormValue() => (createdAt: clock.now(), price: value.data.price),
      PaymentGridsModifyFormValue() => (createdAt: value.data.createdAt, price: value.data.price),
    };

    final DateTime date = record.createdAt;
    final String price = AppMoney(record.price).formatted;
    final ThemeProvider theme = ThemeProvider.of(context);

    return Container(
      width: kGridWidth,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(5.0),
        color: payment != null ? kPrimaryColor : kHintColor,
        child: InkWell(
          onTap: payment != null ? () => context.registry.get<PaymentsCoordinator>().toPayment(payment) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: date.day.toString(),
                          style: theme.subhead3.copyWith(fontWeight: AppFontWeight.medium, color: Colors.white),
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: '${AppStrings.monthsShort[date.month - 1].toUpperCase()}, ${date.year}',
                          style: theme.xxsmall.copyWith(fontWeight: AppFontWeight.medium, color: Colors.white),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Text(price, style: theme.title.copyWith(color: Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
