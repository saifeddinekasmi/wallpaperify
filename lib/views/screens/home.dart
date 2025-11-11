import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperify/controller/api_service.dart';
import 'package:wallpaperify/model/model_category.dart';
import 'package:wallpaperify/model/models_photo.dart';
import 'package:wallpaperify/views/screens/image.dart';
import 'package:wallpaperify/views/widgets/myappbar.dart';
import 'package:wallpaperify/views/widgets/search.dart';
import 'package:wallpaperify/views/widgets/pageforit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<GetPhotos> trendingWallList;
  late List<CategoryModel> modlist;
  bool isLoading = true;

  detailsGet() async {
    modlist = Api.getCategoriesList();
    setState(() {});
  }

  getTrendingWallpapers() async {
    trendingWallList = await Api.getTrendingWallpapers();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    detailsGet();
    getTrendingWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
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
          : RefreshIndicator(
              onRefresh: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // ✅ Custom Search
                      CustomSearchBar(),

                      const SizedBox(height: 20),

                      // ✅ Categories Title
                      Text(
                        "Categories",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ✅ Categories Horizontal List
                      SizedBox(
                        height: 95,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: modlist.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return CatBlock(
                              categorySrcImg: modlist[index].catImgUrl,
                              nameCategory: modlist[index].catName,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ✅ Trending Wallpapers Title
                      Text(
                        "Trending",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ✅ Trending Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trendingWallList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        itemBuilder: (context, index) {
                          final img = trendingWallList[index].imgSrc;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullImage(imgUrl: img)));
                            },
                            child: Hero(
                              tag: img,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
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

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
