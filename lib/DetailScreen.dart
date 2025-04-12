import 'package:flutter/material.dart';
import 'Model/DualBarData.dart';

class DetailScreen extends StatelessWidget {
  final DualBarData item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(item);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Scaffold(
      appBar: AppBar(
        title: Text('${item.tiltle} Detail'),
        backgroundColor: statusColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.tiltle,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildInfoRow("Actual", "${item.actual} K\$"),
                _buildInfoRow("Target", "${item.target} K\$"),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor),
                    const SizedBox(width: 10),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text('$title:', style: TextStyle(fontSize: 18))),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _getStatus(DualBarData item) {
    if (item.actual > item.target) return 'Over Target';
    if (item.actual < item.target) return 'Under Target';
    return 'Target Achieved';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Over Target':
        return Colors.red;
      case 'Target Achieved':
        return Colors.green;
      case 'Under Target':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Over Target':
        return Icons.trending_up;
      case 'Target Achieved':
        return Icons.check_circle;
      case 'Under Target':
        return Icons.trending_down;
      default:
        return Icons.help_outline;
    }
  }
}
