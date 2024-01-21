import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';

userDetails({required String title, required String icon}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          imageSvg(src: icon, size: 20, color: secondryColor),
          const SizedBox(
            width: 20,
          ),
          Container(
            height: 35,
            width: 1,
            color: primaryColor,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Text(
            title,
            style: const TextStyle(fontSize: 16, color: primaryColor),
          ))
        ],
      ),
    ),
  );
}
