import 'package:flutter/material.dart';
import '../models/photo.dart';

class DetailScreen extends StatelessWidget {
  final Photo photo;
  final VoidCallback onDelete;

  const DetailScreen({
    super.key,
    required this.photo,
    required this.onDelete,
  });

  void _showInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                photo.title,
                key: const Key('info_sheet_title'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 24),
              _InfoRow(
                key: const ValueKey('info_date'),
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: photo.date,
              ),
              const Divider(height: 24),
              _InfoRow(
                key: const ValueKey('info_resolution'),
                icon: Icons.photo_size_select_actual_outlined,
                label: 'Resolution',
                value: '400 × 400 px',
              ),
              const Divider(height: 24),
              _InfoRow(
                key: const ValueKey('info_format'),
                icon: Icons.image_outlined,
                label: 'Format',
                value: 'JPEG',
              ),
              const Divider(height: 24),
              _InfoRow(
                key: const ValueKey('info_source'),
                icon: Icons.link_rounded,
                label: 'Source',
                value: 'picsum.photos',
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.delete_outline_rounded,
          size: 36,
          color: Theme.of(context).colorScheme.error,
        ),
        title: const Text(
          'Delete photo?',
          key: Key('delete_dialog_title'),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'This photo will be removed from your gallery.',
          key: Key('delete_dialog_content'),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          OutlinedButton(
            key: const Key('delete_dialog_cancel'),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('delete_dialog_confirm'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              onDelete();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      key: const Key('detail_scaffold'),
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          photo.title,
          key: const Key('detail_photo_title'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Colors.transparent],
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            key: const Key('detail_interactive_viewer'),
            minScale: 0.8,
            maxScale: 4.0,
            child: Center(
              child: Hero(
                tag: 'photo_${photo.id}',
                child: Image.network(
                  key: const Key('detail_photo_image'),
                  photo.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: Colors.white54,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              padding: EdgeInsets.fromLTRB(32, 40, 32, bottomPadding + 28),
              child: Row(
                key: const Key('detail_action_bar'),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    key: const ValueKey('info_button'),
                    icon: Icons.info_outline_rounded,
                    label: 'Info',
                    onTap: () => _showInfo(context),
                  ),
                  _ActionButton(
                    key: const ValueKey('delete_button'),
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete',
                    onTap: () => _confirmDelete(context),
                    color: colorScheme.error,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: effectiveColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: effectiveColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final keyId = label.toLowerCase();

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 14),
        Text(
          label,
          key: Key('info_row_label_$keyId'),
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        Text(
          value,
          key: Key('info_row_value_$keyId'),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
