import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  final int initialRating;
  final Function(int) onRatingSelected;

  const StarRatingWidget({
    Key? key,
    this.initialRating = 0,
    required this.onRatingSelected,
  }) : super(key: key);

  @override
  _StarRatingWidgetState createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingSelected(_currentRating);
          },
        );
      }),
    );
  }
}
