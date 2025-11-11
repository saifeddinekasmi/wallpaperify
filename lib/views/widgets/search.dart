import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallpaperify/views/screens/search.dart';

// ignore: must_be_immutable
class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ✅ Search Icon
              Icon(Iconsax.search_normal_1,
                  size: 22, color: Colors.black.withOpacity(0.7)),

              const SizedBox(width: 10),

              // ✅ Input Field
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search wallpapers...",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              // ✅ Search Button
              GestureDetector(
                onTap: () {
                  final searchText = _searchController.text.trim();
                  if (searchText.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(query: searchText),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF007B),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Iconsax.arrow_right_3,
                    color: Colors.white,
                    size: 20,
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
