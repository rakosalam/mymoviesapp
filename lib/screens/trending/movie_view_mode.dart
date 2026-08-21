import 'package:flutter/material.dart';

/// How the trending results are laid out: a poster grid or a scrolling list.
enum MovieViewMode {
  grid(Icons.view_list_outlined),
  list(Icons.grid_view_outlined);

  const MovieViewMode(this.toggleIcon);

  /// Icon shown on the toggle button — represents the mode you'd switch TO.
  final IconData toggleIcon;

  MovieViewMode get next => this == grid ? list : grid;
}
