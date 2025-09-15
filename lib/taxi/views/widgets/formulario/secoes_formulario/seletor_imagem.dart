import 'dart:io' as io; // para Mobile/Desktop
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SeletorImagem extends StatefulWidget {
  final String? imagemSelecionada;
  final Function(Uint8List? webImage, String? path) onImagemSelecionada;

  const SeletorImagem({
    super.key,
    required this.imagemSelecionada,
    required this.onImagemSelecionada,
  });

  @override
  State<SeletorImagem> createState() => _SeletorImagemState();
}

class _SeletorImagemState extends State<SeletorImagem> {
  Uint8List? webImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() => webImage = bytes);
        widget.onImagemSelecionada(bytes, null);
      } else {
        setState(() {});
        widget.onImagemSelecionada(null, pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botão de seleção de imagem
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Selecionar Imagem'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        // Preview da imagem
        if ((widget.imagemSelecionada?.isNotEmpty ?? false) || webImage != null) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Imagem selecionada:',
                //   style: theme.textTheme.bodyMedium?.copyWith(
                //     color: theme.brightness == Brightness.dark
                //         ? Colors.white
                //         : Colors.black87,
                //   ),
                // ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: themeProvider.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: kIsWeb && webImage != null
                        ? Image.memory(
                      webImage!,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                        : (widget.imagemSelecionada != null &&
                        widget.imagemSelecionada!.isNotEmpty)
                        ? Image.file(
                      io.File(widget.imagemSelecionada!),
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
