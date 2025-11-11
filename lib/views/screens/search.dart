import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperify/controller/api_service.dart';
import 'package:wallpaperify/model/models_photo.dart';
import 'package:wallpaperify/views/screens/image.dart';
import 'package:wallpaperify/views/widgets/myappbar.dart';
import 'package:wallpaperify/views/widgets/search.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<GetPhotos> searchResults;
  bool isLoading = true;

  Future<void> getSearchResults() async {
    searchResults = await Api.searchWallpapers(widget.query);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: const CustomAppBar(),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                color: Colors.black,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // ✅ Search Bar
                    CustomSearchBar(),

                    const SizedBox(height: 20),

                    // ✅ Title
                    Text(
                      "Results for \"${widget.query}\"",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ✅ Grid of images
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                      itemBuilder: (context, index) {
                        final img = searchResults[index].imgSrc;

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullImage(imgUrl: img),
                            ),
                          ),
                          child: Hero(
                            tag: img,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 7,
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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
