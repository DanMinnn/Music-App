import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music/common/helper/is_dark.dart';
import 'package:music/common/widgets/appbar/app_bar.dart';
import 'package:music/core/configs/assets/app_images.dart';
import 'package:music/core/configs/assets/app_vectors.dart';
import 'package:music/core/configs/theme/app_colors.dart';
import 'package:music/presentation/home/widgets/news_song.dart';
import 'package:music/presentation/home/widgets/play_list.dart';
import 'package:music/presentation/profile/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
        action: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
          icon: Icon(
            Icons.person,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _topHomeCard(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: [
                  NewsSong(),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            PlayListSongs(),
          ],
        ),
      ),
    );
  }

  Widget _topHomeCard() {
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.topHomeCard),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(AppImages.homeArtist),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
        controller: _tabController,
        labelColor: context.isDarkMode ? Colors.white : Colors.black,
        indicatorColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        tabs: [
          Text(
            'News',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Video',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Artist',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Podcast',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        ]);
  }
}
