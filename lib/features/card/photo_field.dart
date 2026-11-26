import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/card_photo.dart';
import '../../providers.dart';
import '../../services/photo_picker.dart';
import '../../services/photo_processor.dart';
import '../../theme/tokens.dart';
import 'photo_crop_screen.dart';

/// The card photo with buttons to choose, take, or remove it. It saves
/// nothing itself: [onChanged] gets the finished JPEG, or null to remove.
class PhotoField extends ConsumerStatefulWidget {
  final Uint8List? photo;
  final Future<void> Function(Uint8List? jpeg) onChanged;

  const PhotoField({super.key, required this.photo, required this.onChanged});

  @override
  ConsumerState<PhotoField> createState() => _PhotoFieldState();
}

class _PhotoFieldState extends ConsumerState<PhotoField> {
  bool _busy = false;

  Future<void> _pick(PhotoFrom from) async {
    // Opening the picker must be the first thing after the tap (Safari).
    final picking = ref.read(photoPickerProvider).pick(from);
    setState(() => _busy = true);
    try {
      final bytes = await picking;
      if (bytes == null || !mounted) return;
      final image = await openPickedPhoto(bytes);
      if (!mounted) {
        image.dispose();
        return;
      }
      // The crop screen frees the picture, once it is really gone: it is
      // still being drawn while the screen slides away.
      final jpeg = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(builder: (_) => PhotoCropScreen(photo: image)),
      );
      if (jpeg != null) await widget.onChanged(jpeg);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เปิดรูปนี้ไม่ได้ ลองรูปอื่น หรือถ่ายใหม่'),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canTake = ref.watch(platformCapabilitiesProvider).takePhoto;
    final photo = widget.photo;
    const width = 72.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width,
          height: width / cardPhotoAspect,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(GlowRadius.button),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: _busy
              ? const Center(child: CircularProgressIndicator())
              : photo == null
              ? const Icon(Icons.person_outline, size: 32)
              : Image.memory(
                  photo,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  semanticLabel: 'รูปบนบัตร',
                ),
        ),
        const SizedBox(width: GlowSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'รูปถ่ายบนบัตร (ไม่ใส่ก็ได้) เก็บในเครื่องนี้เท่านั้น',
                style: theme.textTheme.bodyMedium,
              ),
              Wrap(
                spacing: GlowSpacing.xs,
                children: [
                  TextButton(
                    onPressed: _busy ? null : () => _pick(PhotoFrom.gallery),
                    child: const Text('เลือกรูป'),
                  ),
                  if (canTake)
                    TextButton(
                      onPressed: _busy ? null : () => _pick(PhotoFrom.camera),
                      child: const Text('ถ่ายรูป'),
                    ),
                  if (photo != null)
                    TextButton(
                      onPressed: _busy ? null : () => widget.onChanged(null),
                      child: const Text('ลบรูป'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
