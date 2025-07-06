import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

/// KYK Yurt Yemekleri için özel tasarlanmış shimmer loading widget'ı
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? Constants.kykGray700 : Constants.kykGray200,
      highlightColor: isDark ? Constants.kykGray600 : Constants.kykGray100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarih navigasyonu shimmer
            _buildDateNavigationShimmer(isDark),
            const SizedBox(height: Constants.space4),
            
            // Ana menü kartı shimmer
            _buildMainMenuCardShimmer(isDark),
            const SizedBox(height: Constants.space4),
            
            // Gelecek günler başlığı shimmer
            _buildSectionTitleShimmer(isDark),
            const SizedBox(height: Constants.space3),
            
            // Gelecek menü kartları shimmer
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: Constants.space2),
              child: _buildUpcomingMenuCardShimmer(isDark),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDateNavigationShimmer(bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Constants.kykGray700 : Constants.kykGray200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sol ok
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(Constants.space3),
            decoration: BoxDecoration(
              color: isDark ? Constants.kykGray600 : Constants.kykGray300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          
          // Tarih bilgisi
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 20,
                decoration: BoxDecoration(
                  color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: Constants.space2),
              Container(
                width: 80,
                height: 16,
                decoration: BoxDecoration(
                  color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          
          // Sağ ok
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(Constants.space3),
            decoration: BoxDecoration(
              color: isDark ? Constants.kykGray600 : Constants.kykGray300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenuCardShimmer(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Constants.kykGray700 : Constants.kykGray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Başlık bölümü
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: isDark ? Constants.kykGray600 : Constants.kykGray300,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Constants.space4),
              child: Row(
                children: [
                  // İkon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Constants.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: Constants.space3),
                  
                  // Başlık ve tarih
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Constants.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: Constants.space2),
                        Container(
                          width: 150,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Constants.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Kalori badge
                  Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Constants.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // İçerik bölümü
          Padding(
            padding: const EdgeInsets.all(Constants.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Bugünün Menüsü" başlığı
                Container(
                  width: 140,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: Constants.space4),
                
                // Kategori 1
                _buildCategoryShimmer(isDark),
                const SizedBox(height: Constants.space3),
                
                // Kategori 2
                _buildCategoryShimmer(isDark),
                const SizedBox(height: Constants.space3),
                
                // Kategori 3
                _buildCategoryShimmer(isDark),
                const SizedBox(height: Constants.space4),
                
                // Detay butonu
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Constants.kykGray700 : Constants.kykGray200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryShimmer(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kategori başlığı
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: Constants.space2),
            Container(
              width: 80,
              height: 18,
              decoration: BoxDecoration(
                color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: Constants.space2),
        
        // Yemek öğeleri
        ...List.generate(2, (index) => Padding(
          padding: const EdgeInsets.only(bottom: Constants.space2),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: Constants.space2),
              Expanded(
                child: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: Constants.space2),
              Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  color: isDark ? Constants.kykGray700 : Constants.kykGray200,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildSectionTitleShimmer(bool isDark) {
    return Container(
      width: 120,
      height: 24,
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray600 : Constants.kykGray300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildUpcomingMenuCardShimmer(bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Constants.kykGray700 : Constants.kykGray200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Constants.space3),
        child: Row(
          children: [
            // İkon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: Constants.space3),
            
            // İçerik
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: Constants.space2),
                  Container(
                    width: 80,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            
            // Ok ikonu
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}