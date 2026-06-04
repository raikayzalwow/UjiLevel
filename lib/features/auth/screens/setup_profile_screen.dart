import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'success_screen.dart';

class SetupProfileScreen extends StatefulWidget {
  final String email;

  const SetupProfileScreen({super.key, required this.email});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSaving = false;

  // Variabel penampung berkas citra foto profil yang dipilih
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Fungsi internal untuk memicu sistem mengambil/memilih gambar
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth:
            500, // Membatasi lebar max gambar untuk menghemat penyimpanan memori
        maxHeight: 500, // Membatasi tinggi max gambar
        imageQuality:
            85, // Mengompresi kualitas gambar sedikit agar load aplikasi ringan
      );
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Gagal mengambil gambar: $e');
    }
  }

  // Menampilkan BottomSheet opsi pilihan (Kamera atau Galeri)
  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Foto Profil',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3D39),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined,
                      color: Color(0xFF507E7B)),
                  title: const Text('Ambil Lewat Kamera',
                      style: TextStyle(fontFamily: 'PlusJakartaSans')),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image_search_outlined,
                      color: Color(0xFF507E7B)),
                  title: const Text('Pilih dari Galeri',
                      style: TextStyle(fontFamily: 'PlusJakartaSans')),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveProfile() async {
    if (_nameController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi seluruh data profil Anda.'),
          backgroundColor: Color(0xFF1B3D39),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Di sini nanti Anda bisa mengunggah _pickedImage ke Firebase Storage jika diperlukan
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SuccessScreen()),
      );
    }
  }

  // Widget pembantu manajemen penampilan gambar avatar
  ImageProvider? _getAvatarImage() {
    if (_pickedImage != null) {
      if (kIsWeb) {
        // Jika berjalan di platform Web, panggil lewat Network URL internal blob
        return NetworkImage(_pickedImage!.path);
      } else {
        // Jika berjalan di Android/iOS Mobile, ambil lewat objek File sistem
        return FileImage(File(_pickedImage!.path));
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Lengkapi Profil',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            color: Color(0xFF1B3D39),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    children: [
                      // === MODIFIKASI LINGKARAN AVATAR FOTO ===
                      GestureDetector(
                        onTap:
                            _showImageSourceBottomSheet, // Klik area lingkaran untuk ganti foto
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor:
                              const Color(0xFF1B3D39).withOpacity(0.1),
                          backgroundImage:
                              _getAvatarImage(), // Menampilkan foto jika sudah dipilih
                          child: _pickedImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 55,
                                  color: Color(0xFF1B3D39),
                                )
                              : null, // Icon hilang otomatis ketika gambar berhasil di-load
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap:
                              _showImageSourceBottomSheet, // Klik tombol kamera kecil
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF507E7B),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                _buildLabel('Nama Lengkap'),
                _buildTextField(
                  controller: _nameController,
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20),
                _buildLabel('Nama Pengguna'),
                _buildTextField(
                  controller: _usernameController,
                  hint: 'Masukkan nama pengguna',
                  icon: Icons.alternate_email_rounded,
                ),
                const SizedBox(height: 20),
                _buildLabel('Alamat Email'),
                _buildTextField(
                  controller: _emailController,
                  hint: 'Alamat Email',
                  readOnly: true,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                _buildLabel('Nomor Telepon'),
                _buildTextField(
                  controller: _phoneController,
                  hint: 'Contoh: 081234567890',
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(height: 44),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3D39),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Simpan Profil',
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
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B3D39),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: 'PlusJakartaSans',
        color: readOnly ? Colors.grey.shade600 : const Color(0xFF1B3D39),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: readOnly ? Colors.grey.shade400 : const Color(0xFF507E7B),
          size: 20,
        ),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1B3D39), width: 1.5),
        ),
      ),
    );
  }
}
