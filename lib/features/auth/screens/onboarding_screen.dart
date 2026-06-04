import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'titleTop': 'Wujudkan',
      'titleBottom': 'Hunian Nyaman',
      'subtitle':
          'Hadirkan kehangatan dan estetika di setiap sudut ruang tempat Anda bernaung.',
      'images': [
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=600&q=80', // Kursi bouclé
        'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=600&q=80', // Cermin wavy
        'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=600&q=80', // Ruang tamu
      ],
    },
    {
      'titleTop': 'Temukan',
      'titleBottom': 'Karaktermu',
      'subtitle':
          'Ekspresikan diri Anda melalui kurasi furnitur pilihan yang dikurasi secara personal.',
      'images': [
        'https://images.unsplash.com/photo-1538688525198-9b88f6f53126?w=600&q=80', // Lampu retro
        'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=600&q=80', // Kabinet hijau
        'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=600&q=80', // Meja sudut
      ],
    },
    {
      'titleTop': 'Mulai',
      'titleBottom': 'Langkahmu',
      'subtitle':
          'Sederhanakan proses penataan ruang impian. Mari mulai perjalanan estetik Anda.',
      'images': [
        'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=600&q=80', // BARU: Dekorasi meja kerja/vas minimalis aktif
        'https://images.unsplash.com/photo-1532372320572-cda25653a26d?w=600&q=80', // BARU: Tanaman indoor & sudut estetik aktif
      ],
    },
  ];

  void _navigateTo(Widget targetScreen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => targetScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double statusBarPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Positioned(
                        right: -40,
                        bottom: screenHeight * 0.1,
                        child: Icon(
                          Icons.star,
                          size: 240,
                          color: Colors.white.withValues(alpha: 0.03),
                        ),
                      ),

                      // tombol lewati
                      Positioned(
                        top: 16,
                        right: 24,
                        child: TextButton(
                          onPressed: () => _navigateTo(const LoginScreen()),
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                          child: Text(
                            'Lewati',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 70, 32, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: screenHeight * 0.38,
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) =>
                                    setState(() => _currentPage = index),
                                itemCount: _pages.length,
                                itemBuilder: (context, index) {
                                  final data = _pages[index];
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    child: Container(
                                      key: ValueKey<int>(index),
                                      child: index == 0
                                          ? _buildFrameOneLayout(data['images'])
                                          : index == 1
                                              ? _buildFrameTwoLayout(
                                                  data['images'])
                                              : _buildFrameThreeLayout(
                                                  data['images']),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 36),

                            Text(
                              _pages[_currentPage]['titleTop'],
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  bottom: 2,
                                  left: -4,
                                  child: Transform(
                                    transform: Matrix4.skewX(-0.15),
                                    child: Container(
                                      width: 195,
                                      height: 22,
                                      color:
                                          Colors.white.withValues(alpha: 0.12),
                                    ),
                                  ),
                                ),
                                Text(
                                  _pages[_currentPage]['titleBottom'],
                                  style: const TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: Text(
                                _pages[_currentPage]['subtitle'],
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.55),
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            const Spacer(),
                            const SizedBox(height: 32),

                            Row(
                              children: List.generate(
                                _pages.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(right: 6),
                                  height: 3,
                                  width: _currentPage == index ? 24 : 10,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // tombol masuk dan daftar
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                onPressed: () =>
                                    _navigateTo(const LoginScreen()),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _navigateTo(const RegisterScreen()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFrameOneLayout(List<String> images) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(44),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(44),
                  ),
                  child: _buildImage(images[0]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(44),
                    bottomLeft: Radius.circular(44),
                    bottomRight: Radius.circular(16),
                  ),
                  child: _buildImage(images[1]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: _buildImage(images[2]),
          ),
        ),
      ],
    );
  }

  Widget _buildFrameTwoLayout(List<String> images) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: _buildImage(images[0]),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildImage(images[2]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(90),
              bottomRight: Radius.circular(90),
            ),
            child: _buildImage(images[1]),
          ),
        ),
      ],
    );
  }

  Widget _buildFrameThreeLayout(List<String> images) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: _buildImage(images[0]),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AspectRatio(
            aspectRatio: 0.7,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.elliptical(70, 90)),
              child: _buildImage(images[1]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String url) {
    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.white.withValues(alpha: 0.04),
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: Colors.white30,
                strokeWidth: 1.5,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.white.withValues(alpha: 0.04),
        child: const Icon(Icons.broken_image_outlined,
            color: Colors.white24, size: 24),
      ),
    );
  }
}
