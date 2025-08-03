import 'package:flutter/material.dart';

class PriceSlider extends StatelessWidget {
  final double minPrice;
  final double maxPrice;
  final ValueChanged<RangeValues> onChanged;

  const PriceSlider({
    required this.minPrice,
    required this.maxPrice,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: RangeValues(minPrice, maxPrice),
      min: 0,
      max: 200,
      divisions: 10,
      labels: RangeLabels('\$${minPrice.toInt()}', '\$${maxPrice.toInt()}'),
      onChanged: onChanged,
    );
  }
}
