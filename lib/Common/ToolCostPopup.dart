import 'package:flutter/material.dart';
import '../Detail/ToolCostDetail.dart';

class ToolCostPopup extends StatelessWidget {
  final String title;
  final List<ToolCostDetail> data;

  const ToolCostPopup({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 12,
      backgroundColor: theme.colorScheme.surface,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth:   MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 24),
              Expanded(child: _buildDataTable(context, theme)),
              const SizedBox(height: 24),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Divider(color: theme.dividerColor, thickness: 1),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context, ThemeData theme) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 10,
      radius: const Radius.circular(5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: theme.dividerColor.withOpacity(0.5)),
          columnWidths: {
            0: FixedColumnWidth(150), // Adjust width for the first column
            1: FixedColumnWidth(200), // Adjust width for the second column
            2: FixedColumnWidth(250), // Adjust width for the third column
            3: FixedColumnWidth(300), // Adjust width for the fourth column
            4: FixedColumnWidth(200),  // Adjust width for the fifth column
            5: FixedColumnWidth(180), // Adjust width for the sixth column
            6: FixedColumnWidth(200), // Adjust width for the seventh column
          },
          children: [
            // Header Row
            TableRow(
              children: [
                _buildTableCell('Div', isHeader: true),
                _buildTableCell('Group', isHeader: true),
                _buildTableCell('Tcode', isHeader: true),
                _buildTableCell('Name', isHeader: true),
                _buildTableCell('Qty', isHeader: true),
                _buildTableCell('Amount', isHeader: true),
                _buildTableCell('Used Date', isHeader: true),
              ],
            ),
            // Data Rows
            ...data.map((item) {
              return TableRow(
                children: [
                  _buildTableCell(item.div),
                  _buildTableCell(item.group),
                  _buildTableCell(item.tcode),
                  _buildTableCell(item.name),
                  _buildTableCell(item.qty.toString(), numeric: true),
                  _buildTableCell(item.amount.toString()),
                  _buildTableCell(item.usedDate),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, bool numeric = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust the horizontal padding for spacing between columns
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
          color: highlight ? Colors.blue.shade700 : null,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Close', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
