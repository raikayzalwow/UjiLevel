import '../models/product.dart';
import '../models/notification.dart';

class MockDataService {
  static List<Product> getProducts() {
    return [

      // ── Sofa ────────────────────────────────────────────────────────────────
      Product(
        id: 'sofa_001',
        name: 'Pumpkin Sofa',
        category: 'Sofa',
        description: 'Sofa pumpkin ikonik dengan desain gelembung berlekuk yang unik dan memukau. '
            'Material teddy fleece ultra-lembut yang nyaman disentuh dan tahan lama. '
            'Kaki berbahan stainless steel gold yang mewah dan kokoh.',
        price: 4500000,
        rating: 4.8,
        reviewCount: 124,
        images: [
          'assets/images/sofa_pumpkin_1.png',
          'assets/images/sofa_pumpkin_2.png',
          'assets/images/sofa_pumpkin_3.png',
        ],
        colors: ['#978F66', '#F1E2D1', '#2F6B3F'],
        styles: ['Modern', 'Minimalis'],
      ),
      Product(
        id: 'sofa_002',
        name: 'Modern Square Arm Sofa',
        category: 'Sofa',
        description: 'Sofa 3 dudukan dengan desain lengan kotak yang tegas dan modern. '
            'Dudukan dalam dan empuk memberikan kenyamanan duduk maupun berbaring. '
            'Material fabric woven premium yang breathable dan tahan lama.',
        price: 7200000,
        rating: 4.7,
        reviewCount: 89,
        images: [
          'assets/images/sofa_002_1.png',
          'assets/images/sofa_002_2.png',
        ],
        colors: ['#C2A56D', '#605B51'],
        styles: ['Modern', 'Minimalis'],
      ),
      Product(
        id: 'sofa_003',
        name: 'Japandi Wooden Sofa',
        category: 'Sofa',
        description: 'Sofa bergaya Japandi dengan rangka kayu walnut terlihat. '
            'Desain terbuka dan ringan menciptakan kesan ruang yang lebih luas. '
            'Bantal duduk dan sandaran bisa dilepas dan dicuci.',
        price: 5500000,
        rating: 4.9,
        reviewCount: 43,
        images: [
          'assets/images/sofa_japandi_1.png',
          'assets/images/sofa_japandi_2.png',
          'assets/images/sofa_japandi_3.png',
        ],
        colors: ['#412D15', '#E7E1B1', '#FA6781'],
        styles: ['Japandi', 'Minimalis'],
      ),
      Product(
        id: 'sofa_004',
        name: 'Modular Corner Sofa',
        category: 'Sofa',
        description: 'Sofa modular yang bisa dikonfigurasi sesuai kebutuhan ruangan. '
            'Terdiri dari 5 modul yang bisa disusun berbagai cara. '
            'Material microfiber lembut dan mudah dibersihkan.',
        price: 9500000,
        rating: 4.7,
        reviewCount: 38,
        images: [
          'assets/images/sofa_modular_1.jpg',
          'assets/images/sofa_modular_2.jpg',
        ],
        colors: ['#6B8F71', '#093C5D'],
        styles: ['Modern', 'Skandinavia'],
      ),
      Product(
        id: 'sofa_005',
        name: 'Chester Sofa Klasik',
        category: 'Sofa',
        description: 'Sofa Chester klasik dengan detail tufting elegan. '
            'Rangka kayu mahoni solid yang kuat dan berat. '
            'Kaki kayu ukiran memberikan kesan mewah klasik.',
        price: 8200000,
        rating: 4.8,
        reviewCount: 29,
        images: [
          'assets/images/sofa_chester_1.jpg',
          'assets/images/sofa_chester_2.jpg',
          // sofa_chester_3.jpg tidak ada di folder, dihapus
        ],
        colors: ['#6B2D2D', '#1C3A1C', '#2C1B47'],
        styles: ['Klasik', 'Mewah'],
      ),

      // ── Kursi ───────────────────────────────────────────────────────────────
      Product(
        id: 'kursi_001',
        name: 'Lounge Chair Rotan',
        category: 'Kursi',
        description: 'Kursi santai dari rotan alami pilihan yang kuat dan ringan. '
            'Bantal duduk tebal dari busa HR40 dengan cover katun yang bisa dicuci. '
            'Cocok untuk sudut baca, teras, atau ruang keluarga.',
        price: 1200000,
        rating: 4.6,
        reviewCount: 89,
        images: [
          'assets/images/kursi_lounge_rotan_1.jpg',
        ],
        colors: ['#C8A882'],
        styles: ['Natural', 'Boho'],
      ),
      Product(
        id: 'kursi_002',
        name: 'Accent Chair Velvet',
        category: 'Kursi',
        description: 'Kursi aksen berbentuk bulat dengan material velvet mewah. '
            'Kaki emas berbahan metal solid memberikan kesan premium. '
            'Menjadi statement piece yang sempurna untuk ruang tamu.',
        price: 1800000,
        rating: 4.8,
        reviewCount: 54,
        images: [
          'assets/images/kursi_accent_velvet_1.jpg',
          'assets/images/kursi_accent_velvet_2.png', // ekstensi .png bukan .jpg
        ],
        colors: ['#4A6FA5', '#8B4A6B'],
        styles: ['Modern', 'Mewah'],
      ),
      Product(
        id: 'kursi_003',
        name: 'Kursi Kerja Ergonomis',
        category: 'Kursi',
        description: 'Kursi kerja ergonomis dengan dukungan lumbar yang bisa diatur. '
            'Sandaran mesh breathable menjaga sirkulasi udara saat bekerja lama. '
            'Tinggi kursi dan sudut sandaran bisa disesuaikan.',
        price: 3200000,
        rating: 4.7,
        reviewCount: 312,
        images: [
          'assets/images/kursi_ergonomis_1.jpg',
          'assets/images/kursi_ergonomis_2.jpg',
        ],
        colors: ['#2C2C2C', '#1B4F72'],
        styles: ['Ergonomis', 'Modern'],
      ),
      Product(
        id: 'kursi_004',
        name: 'Egg Chair dengan Ottoman',
        category: 'Kursi',
        description: 'Kursi egg chair ikonik dilengkapi ottoman yang serasi. '
            'Bisa berputar 360 derajat untuk kenyamanan maksimal. '
            'Material kulit sintetis premium yang lembut dan mudah dirawat.',
        price: 4500000,
        rating: 4.8,
        reviewCount: 47,
        images: [
          'assets/images/kursi_egg_1.jpg',
        ],
        colors: ['#434347'],
        styles: ['Ikonik', 'Modern'],
      ),

      // ── Meja ────────────────────────────────────────────────────────────────
      Product(
        id: 'meja_001',
        name: 'Walnut Dining Table',
        category: 'Meja',
        description: 'Meja makan dari kayu walnut solid dengan finishing natural oil. '
            'Serat kayu yang unik membuat setiap produk berbeda dan istimewa. '
            'Kaki berbentuk trapezoid yang stabil dan estetik. Cocok untuk 6 orang.',
        price: 6800000,
        rating: 4.9,
        reviewCount: 67,
        images: [
          'assets/images/meja_walnut_dining_1.jpg',
          'assets/images/meja_walnut_dining_2.jpg',
        ],
        colors: ['#0c0604', '#d3c4b2'],
        styles: ['Natural', 'Modern'],
      ),
      Product(
        id: 'meja_002',
        name: 'Coffee Table Marmer',
        category: 'Meja',
        description: 'Meja kopi dengan top marmer asli Carrara Italia. '
            'Kaki metal hitam matte yang kontras dengan marmer putih. '
            'Tampilan mewah yang cocok untuk ruang tamu modern.',
        price: 3500000,
        rating: 4.8,
        reviewCount: 45,
        images: [
          'assets/images/meja_coffee_marmer_1.jpg',
          'assets/images/meja_coffee_marmer_2.jpg',
        ],
        colors: ['#F5F5F0', '#2C2C2C'],
        styles: ['Mewah', 'Modern'],
      ),
      Product(
        id: 'meja_003',
        name: 'Standing Desk Elektrik',
        category: 'Meja',
        description: 'Meja kerja dengan sistem naik-turun elektrik untuk ergonomi optimal. '
            'Panel kontrol digital dengan memory 4 posisi. '
            'Motor senyap dengan kecepatan naik turun yang halus.',
        price: 8500000,
        rating: 4.9,
        reviewCount: 42,
        images: [
          'assets/images/meja_standing_desk_1.jpg',
        ],
        colors: ['#FFFFFF'],
        styles: ['Ergonomis', 'Modern'],
      ),

      // ── Lemari ──────────────────────────────────────────────────────────────
      Product(
        id: 'lemari_001',
        name: 'Modular Bookshelf 5 Layer',
        category: 'Lemari',
        description: 'Rak buku modular 5 tingkat yang bisa disusun sesuai kebutuhan. '
            'Bisa ditumpuk vertikal atau disusun horizontal. '
            'Material MDF premium dengan lapisan anti-gores.',
        price: 2300000,
        rating: 4.5,
        reviewCount: 201,
        images: [
          'assets/images/lemari_bookshelf_1.jpg',
        ],
        colors: ['#FFFFFF'],
        styles: ['Minimalis', 'Modern'],
      ),
      Product(
        id: 'lemari_002',
        name: 'Wardrobe 4 Pintu Cermin',
        category: 'Lemari',
        description: 'Lemari pakaian 4 pintu dengan cermin penuh di 2 pintu tengah. '
            'Interior lemari yang terorganisir dengan gantungan baju dan rak sepatu. '
            'Engsel pintu soft-close yang senyap.',
        price: 6500000,
        rating: 4.7,
        reviewCount: 89,
        images: [
          'assets/images/lemari_wardrobe_cermin_1.jpg',
        ],
        colors: ['#FFFFFF'],
        styles: ['Modern', 'Minimalis'],
      ),
      Product(
        id: 'lemari_003',
        name: 'TV Cabinet Modern',
        category: 'Lemari',
        description: 'Kabinet TV modern dengan desain mengambang di dinding. '
            'Dilengkapi LED ambient light di bagian belakang untuk efek sinematik. '
            'Lubang kabel tersembunyi untuk tampilan rapi.',
        price: 2500000,
        rating: 4.6,
        reviewCount: 178,
        images: [
          'assets/images/lemari_tv_cabinet_1.jpg',
        ],
        colors: ['#70542f'],
        styles: ['Modern', 'Minimalis'],
      ),

      // ── Tempat Tidur ─────────────────────────────────────────────────────────
      Product(
        id: 'bed_001',
        name: 'Platform Bed Frame Walnut',
        category: 'Tempat Tidur',
        description: 'Bed frame minimalis dari kayu walnut solid dengan desain platform rendah. '
            'Desain tanpa headboard tinggi memberikan kesan ruangan lebih luas dan modern. '
            'Slat kayu yang kuat tidak memerlukan box spring.',
        price: 5200000,
        rating: 4.7,
        reviewCount: 156,
        images: [
          'assets/images/bed_platform_walnut_1.jpg',
        ],
        colors: ['#D4B896'],
        styles: ['Minimalis', 'Natural'],
      ),
      Product(
        id: 'bed_002',
        name: 'Upholstered Bed Beige',
        category: 'Tempat Tidur',
        description: 'Bed frame berlapis kain linen beige yang lembut dan elegan. '
            'Headboard tinggi empuk untuk bersandar saat membaca. '
            'Kaki kayu ramping bergaya mid-century.',
        price: 4800000,
        rating: 4.8,
        reviewCount: 93,
        images: [
          'assets/images/bed_upholstered_beige_1.jpg',
        ],
        colors: ['#4A4A4A'],
        styles: ['Elegan', 'Romantis'],
      ),

      // ── Lampu ───────────────────────────────────────────────────────────────
      Product(
        id: 'lamp_001',
        name: 'Arc Floor Lamp Linen',
        category: 'Lampu',
        description: 'Lampu lantai dengan lengan melengkung elegan. '
            'Shade dari kain linen natural yang memancarkan cahaya hangat dan difus. '
            'Tiang metal matte hitam yang kokoh dengan base berat anti-jatuh.',
        price: 850000,
        rating: 4.4,
        reviewCount: 93,
        images: [
          'assets/images/lamp_arc_floor_1.jpg',
          'assets/images/lamp_arc_floor_2.jpg',
        ],
        colors: ['#D4AF37', '#C0C0C0'],
        styles: ['Modern', 'Skandinavia'],
      ),
      Product(
        id: 'lamp_002',
        name: 'Pendant Light Rattan',
        category: 'Lampu',
        description: 'Lampu gantung dari rotan alam dengan motif anyaman yang indah. '
            'Cahaya yang menembus anyaman rotan menciptakan pola bayangan unik. '
            'Cocok untuk ruang makan atau ruang tamu boho.',
        price: 450000,
        rating: 4.7,
        reviewCount: 187,
        images: [
          'assets/images/lamp_pendant_rattan_1.jpg',
        ],
        colors: ['#9b7445'],
        styles: ['Boho', 'Natural'],
      ),

      // ── Karpet ──────────────────────────────────────────────────────────────
      Product(
        id: 'karpet_001',
        name: 'Moroccan Wool Rug',
        category: 'Karpet',
        description: 'Karpet wool buatan tangan dari pengrajin Maroko dengan motif geometris otentik. '
            'Dibuat dari wol merino pilihan yang lembut dan tahan lama. '
            'Tebal 12mm memberikan kenyamanan saat duduk atau tiduran.',
        price: 3100000,
        rating: 4.7,
        reviewCount: 78,
        images: [
          'assets/images/karpet_moroccan_1.jpg',
        ],
        colors: ['#E8D5B7'],
        styles: ['Maroko', 'Boho'],
      ),
      Product(
        id: 'karpet_002',
        name: 'Shaggy Rug Fluffy',
        category: 'Karpet',
        description: 'Karpet shaggy berbulu panjang 5cm yang sangat lembut di kaki. '
            'Material polyester premium yang mudah dibersihkan. '
            'Anti-slip backing untuk keamanan.',
        price: 1800000,
        rating: 4.6,
        reviewCount: 234,
        images: [
          'assets/images/karpet_shaggy_1.jpg',
        ],
        colors: ['#FFFFFF'],
        styles: ['Modern', 'Minimalis'],
      ),
      Product(
        id: 'karpet_003',
        name: 'Persian Style Rug',
        category: 'Karpet',
        description: 'Karpet bergaya Persia dengan motif floral yang kaya dan detail. '
            'Warna deep jewel tone yang mewah dan timeless. '
            'Dibuat dengan teknik mesin kualitas tinggi dari benang acrylic premium.',
        price: 4500000,
        rating: 4.8,
        reviewCount: 45,
        images: [
          'assets/images/karpet_persian_1.jpg',
        ],
        colors: ['#2C5F2E'],
        styles: ['Klasik', 'Mewah'],
      ),

      // ── Dekorasi ────────────────────────────────────────────────────────────
      Product(
        id: 'deko_001',
        name: 'Arched Mirror Rattan',
        category: 'Dekorasi',
        description: 'Cermin dinding berbentuk lengkung arch yang elegan. '
            'Bingkai dari rotan alam yang memberikan sentuhan natural. '
            'Ukuran besar memberikan ilusi ruangan yang lebih luas dan terang.',
        price: 980000,
        rating: 4.6,
        reviewCount: 112,
        images: [
          'assets/images/deko_arched_mirror_1.jpg',
        ],
        colors: ['#C8A882'],
        styles: ['Boho', 'Natural'],
      ),
      Product(
        id: 'deko_002',
        name: 'Vas Keramik Set 3',
        category: 'Dekorasi',
        description: 'Set 3 vas keramik dengan ukuran berbeda untuk display bertingkat. '
            'Dibuat dengan teknik potter wheel. Finishing matte yang elegan.',
        price: 580000,
        rating: 4.7,
        reviewCount: 189,
        images: [
          'assets/images/deko_vas_keramik_1.jpg',
        ],
        colors: ['#4A4A4A'],
        styles: ['Minimalis', 'Nordic'],
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------
  static List<AppNotification> getNotifications() {
    return [
      AppNotification(
        id: '1',
        type: 'promo',
        title: 'Diskon 20% produk pilihan',
        message: 'Penawaran terbatas untuk produk furniture modern. Belanja sekarang!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      AppNotification(
        id: '2',
        type: 'transaction',
        title: 'Pesanan kamu dikonfirmasi',
        message: 'Kami sedang mempersiapkan pesananmu dan akan memberi tahu saat dikirim.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      AppNotification(
        id: '3',
        type: 'transaction',
        title: 'Pesanan kamu dikirim',
        message: 'Lacak paketmu untuk melihat update pengiriman terbaru.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      AppNotification(
        id: '4',
        type: 'promo',
        title: 'Flash Sale! Diskon hingga 40%',
        message: 'Hari ini saja: diskon besar untuk kursi dan meja terlaris.',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
      AppNotification(
        id: '5',
        type: 'transaction',
        title: 'Pembayaran diterima',
        message: 'Kami menerima pembayaran untuk pesanan #HM-2024-001.',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ),
      AppNotification(
        id: '6',
        type: 'promo',
        title: 'Koleksi baru minggu ini',
        message: 'Cek koleksi Nordic terbaru yang baru ditambahkan ke toko.',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      ),
      AppNotification(
        id: '7',
        type: 'transaction',
        title: 'Pesanan berhasil diterima',
        message: 'Pesananmu sudah sampai. Nikmati furniture barumu!',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // Banners
  // ---------------------------------------------------------------------------
  static List<Map<String, String>> getBanners() {
    return [
      {
        'image': 'assets/images/sofa_pumpkin_1.png',  // banner diganti pakai gambar yang ada
        'title': 'Sofa Pilihan Terbaik',
      },
      {
        'image': 'assets/images/meja_walnut_dining_1.jpg',
        'title': 'Meja Makan Elegan',
      },
      {
        'image': 'assets/images/bed_platform_walnut_1.jpg',
        'title': 'Kamar Tidur Nyaman',
      },
    ];
  }

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------
  static List<String> getCategories() {
    return [
      'Semua',
      'Sofa',
      'Kursi',
      'Meja',
      'Lemari',
      'Tempat Tidur',
      'Lampu',
      'Karpet',
      'Dekorasi',
    ];
  }
}