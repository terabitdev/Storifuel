import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/view_model/home/home_provider.dart';

class StoryCard extends StatelessWidget {
  final String storyId;
  final String image;
  final String title;
  final String description;
  final String timeAgo;

  const StoryCard({
    super.key,
    required this.storyId,
    required this.image,
    required this.title,
    required this.description,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesName.storyDetails,
          arguments: {
            'storyId': storyId,
            'image': image,
            'title': title,
            'category': 'Business',
            'timeAgo': timeAgo,
            'tags': ['#news', '#today', '#stock', '#business', '#music', '#technology', '#Crypto'],
            'content': '''Bitcoin is a crypto asset that is a reference for various altcoins that have currently been launched, so its price movements are an important benchmark that has a major impact on other crypto assets.

Start Crypto Asset Investment at Crypto Magic! In 2024, there are many events that are thought to affect the crypto market, starting from the Bitcoin network will experience a reduction in rewards (Halving), the Bitcoin ETF that has been approved, and the Dencun upgrade that will be launched in the near future.

Bitcoin as a Trendsetter

Bitcoin (BTC) has changed the entire financial system as we know it by being an alternative to centralized, government-controlled economies, the blockchain technology used in cryptocurrencies eliminates the need for centralized intermediaries and puts control back in the hands of users.

Its decentralized nature not only challenged conventional notions of financial autonomy, but also spawned a wide array of other alternative cryptocurrencies (altcoins), spreading its influence massively.

Therefore, Bitcoin serves as the ultimate benchmark of crypto market trends and conditions. Its price movements can set the tone for other assets in the crypto space, influencing investor confidence in both Bitcoin and altcoins.''',
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // ✅ Image with Fav Icon overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: Image.asset(
                  image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Consumer<HomeProvider>(
                  builder: (context, provider, _) {
                    final isFavorited = provider.isStoryFavorited(storyId);
                    return GestureDetector(
                      onTap: () => provider.toggleFavorite(storyId),
                      child: Center(
                        child: SvgPicture.asset(
                          isFavorited ? AppImages.favIcon : AppImages.nonFavIcon,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ✅ Text Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: nunitoSans18w700,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppImages.clockIcon,
                            height: 14,
                            width: 14,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeAgo,
                            style: nunito12w400.copyWith(color: Colors.white, fontSize: 10,fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: nunito12w400.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
