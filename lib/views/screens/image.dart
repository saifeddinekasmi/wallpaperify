import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gal/gal.dart';

class FullImage extends StatelessWidget {
  final String imgUrl;

  const FullImage({super.key, required this.imgUrl});

  Future<void> saveImageToGallery(String imageUrl, BuildContext context) async {
    if (!context.mounted) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Downloading...",
            style: GoogleFonts.poppins(),
          ),
        ),
      );

      final file = await DefaultCacheManager().getSingleFile(imageUrl);
      await Gal.putImage(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Saved to Gallery ✅",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ✅ FLOATING BLUR GLASS BUTTON
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FloatingActionButton.extended(
            onPressed: () => saveImageToGallery(imgUrl, context),
            backgroundColor: Colors.white.withOpacity(0.12),
            elevation: 0,
            label: Row(
              children: [
                Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // ✅ FULL IMAGE
          Positioned.fill(
            child: Hero(
              tag: imgUrl,
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ TOP SAFE BACK BUTTON (white)
          Positioned(
            top: 40,
            left: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // ✅ OPTIONAL BOTTOM GRADIENT
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
