import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(_formatLabel(label)),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        backgroundColor: theme.brightness == Brightness.light
            ? Colors.grey[200]
            : Colors.grey[800],
        selectedColor: theme.colorScheme.primary.withOpacity(0.2),
        checkmarkColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? theme.colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isSelected 
              ? BorderSide(color: theme.colorScheme.primary)
              : BorderSide.none,
        ),
      ),
    );
  }

  String _formatLabel(String label) {
    if (label.isEmpty) return label;
    return label[0].toUpperCase() + label.substring(1).replaceAll('-', ' ');
  }
}
