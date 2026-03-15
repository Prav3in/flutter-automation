import 'package:flutter/material.dart';
import 'package:gallary/data/mock_photos.dart';
import '../models/photo.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Photo> _photos;

  @override
  void initState() {
    super.initState();
    _photos = List.from(mockPhotos);
  }

  void _deletePhoto(Photo photo) {
    setState(() {
      _photos.removeWhere((p) => p.id == photo.id);
    });
  }

  void _restorePhotos() {
    setState(() {
      _photos = List.from(mockPhotos);
    });
  }

  void _openPhoto(Photo photo) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(
          photo: photo,
          onDelete: () => _deletePhoto(photo),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Hero handles the image expansion from grid position.
          // This only fades in the black background and UI chrome AFTER
          // the Hero is well into its flight, so the image appears to
          // pop out cleanly before the rest of the screen appears.
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: const Key('home_scaffold'),
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        key: const Key('gallery_scroll_view'),
        slivers: [
          SliverAppBar.large(
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: GestureDetector(
                key: const Key('gallery_title_gesture'),
                onDoubleTap: _restorePhotos,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gallery',
                      key: Key('gallery_title_text'),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        '${_photos.length} photo${_photos.length == 1 ? '' : 's'}',
                        key: ValueKey(_photos.length),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              stretchModes: const [StretchMode.fadeTitle],
            ),
          ),
          if (_photos.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(
                key: const ValueKey('empty_state'),
                onRestore: _restorePhotos,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.82,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _PhotoTile(
                    key: ValueKey(_photos[index].id),
                    photo: _photos[index],
                    index: index,
                    onTap: () => _openPhoto(_photos[index]),
                  ),
                  childCount: _photos.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final Photo photo;
  final int index;
  final VoidCallback onTap;

  const _PhotoTile({
    super.key,
    required this.photo,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 250 + (index * 50).clamp(0, 550)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - value)),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'photo_${photo.id}',
                child: Image.network(
                  key: Key('photo_image_${photo.id}'),
                  photo.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: colorScheme.onSurfaceVariant,
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
                      stops: [0.0, 1.0],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 24, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        photo.title,
                        key: Key('photo_title_${photo.id}'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        photo.date,
                        key: Key('photo_date_${photo.id}'),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRestore;

  const _EmptyState({super.key, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 88,
            color: colorScheme.outlineVariant,
          ),
          const SizedBox(height: 20),
          Text(
            'No photos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your gallery is empty',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
          ),
          const SizedBox(height: 28),
          FilledButton.tonalIcon(
            onPressed: onRestore,
            icon: const Icon(Icons.restore_rounded),
            label: const Text('Restore Photos'),
          ),
        ],
      ),
    );
  }
}
