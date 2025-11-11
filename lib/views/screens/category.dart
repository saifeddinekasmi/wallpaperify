import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperify/controller/api_service.dart';
import 'package:wallpaperify/model/models_photo.dart';
import 'package:wallpaperify/views/screens/image.dart';
import 'package:wallpaperify/views/widgets/myappbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CategoryScreen extends StatefulWidget {
  final String name;
  final String urlImg;

  const CategoryScreen({
    super.key,
    required this.urlImg,
    required this.name,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<GetPhotos> categoryResults;
  bool isLoading = true;

  getCatRelWall() async {
    categoryResults = await Api.searchWallpapers(widget.name);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getCatRelWall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: CustomAppBar(),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                color: Colors.black,
                size: 50,
              ),
            )
          : Column(
              children: [
                // ✅ CATEGORY HEADER
                Stack(
                  children: [
                    ClipRRect(
                      child: Image.network(
                        widget.urlImg,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // ✅ BLUR BLACK OVERLAY
                    Container(
                      height: 170,
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

                    // ✅ CATEGORY TITLE (CENTER)
                    Positioned.fill(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Category",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.name,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ✅ THE GRID
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: categoryResults.length,
                      itemBuilder: (context, index) {
                        final img = categoryResults[index].imgSrc;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullImage(imgUrl: img),
                              ),
                            );
                          },
                          child: Hero(
                            tag: img,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  img,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
