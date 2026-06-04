import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../providers/user_provider.dart';
import '../providers/order_provider.dart';
import '../utils/app_theme.dart';
import 'order_history_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Akun'),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<UserProvider>(
        builder: (ctx, user, _) => SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(context, user),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Akun Saya',
                children: [
                  _buildTile(
                    context,
                    icon: Icons.person_outline,
                    label: 'Informasi pribadi',
                    onTap: () => _showEditProfile(context, user),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.language,
                    label: 'Bahasa',
                    trailing: const Text('Indonesia',
                        style: TextStyle(fontSize: 13, color: AppTheme.grey)),
                    onTap: () => _showLanguageDialog(context),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    label: 'Kebijakan Privasi',
                    onTap: () => _showPrivacyDialog(context),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.settings_outlined,
                    label: 'Pengaturan',
                    onTap: () => _showSettingsDialog(context),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.receipt_long_outlined,
                    label: 'Riwayat Pesanan',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const OrderHistoryScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Notifikasi',
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifikasi Push',
                    value: user.pushNotifications,
                    onChanged: (val) async {
                      await user.togglePushNotifications(val);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.scale,
                        title: val
                            ? 'Notifikasi Push Aktif'
                            : 'Notifikasi Push Nonaktif',
                        desc: val
                            ? 'Kamu akan menerima notifikasi push.'
                            : 'Notifikasi push telah dinonaktifkan.',
                        btnOkOnPress: () {},
                        btnOkColor: AppTheme.primary,
                      ).show();
                    },
                  ),
                  _buildSwitchTile(
                    icon: Icons.campaign_outlined,
                    label: 'Notifikasi Promosi',
                    value: user.promoNotifications,
                    onChanged: (val) async {
                      await user.togglePromoNotifications(val);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.scale,
                        title: val
                            ? 'Notifikasi Promosi Aktif'
                            : 'Notifikasi Promosi Nonaktif',
                        desc: val
                            ? 'Kamu akan mendapat info promo terbaru.'
                            : 'Notifikasi promosi telah dinonaktifkan.',
                        btnOkOnPress: () {},
                        btnOkColor: AppTheme.primary,
                      ).show();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Lainnya',
                children: [
                  _buildTile(
                    context,
                    icon: Icons.help_outline,
                    label: 'Pusat Bantuan',
                    onTap: () => _showHelpDialog(context),
                  ),
                  _buildLogoutTile(context),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: AppTheme.white,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showEditProfile(context, user),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.greyLight,
                  // DIUBAH: ambil photoUrl dari Firestore via UserProvider
                  backgroundImage: user.photoUrl.isNotEmpty
                      ? NetworkImage(user.photoUrl)
                      : null,
                  child: user.photoUrl.isEmpty
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Nama dari Firestore
          Text(
            user.name.isNotEmpty ? user.name : 'Pengguna',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 4),
          // Email dari Firestore
          Text(
            user.email.isNotEmpty ? user.email : '-',
            style: const TextStyle(fontSize: 13, color: AppTheme.grey),
          ),
          // Tambahan: tampilkan username jika ada
          if (user.username.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '@${user.username}',
                style: const TextStyle(fontSize: 12, color: AppTheme.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.black,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.grey, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.black,
                ),
              ),
            ),
            trailing ??
                const Icon(Icons.chevron_right,
                    color: AppTheme.greyLight, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.grey, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppTheme.black),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return InkWell(
      onTap: () => _showLogoutDialog(context),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.logout, color: AppTheme.red, size: 20),
            SizedBox(width: 14),
            Text(
              'Keluar',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Keluar',
      desc: 'Apakah kamu yakin ingin keluar dari akun?',
      btnCancelText: 'Batal',
      btnCancelOnPress: () {},
      btnOkText: 'Keluar',
      btnOkOnPress: () {
        Navigator.of(context).popUntil((r) => r.isFirst);
      },
      btnOkColor: Colors.red,
    ).show();
  }

  void _showLanguageDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Bahasa',
      desc: 'Fitur ganti bahasa akan segera hadir di pembaruan berikutnya.',
      btnOkOnPress: () {},
      btnOkColor: AppTheme.primary,
    ).show();
  }

  void _showPrivacyDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Kebijakan Privasi',
      desc:
          'Data kamu disimpan dengan aman dan tidak akan dibagikan kepada pihak ketiga tanpa izin.',
      btnOkText: 'Mengerti',
      btnOkOnPress: () {},
      btnOkColor: AppTheme.primary,
    ).show();
  }

  void _showSettingsDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Pengaturan',
      desc: 'Halaman pengaturan lengkap akan segera hadir.',
      btnOkOnPress: () {},
      btnOkColor: AppTheme.primary,
    ).show();
  }

  void _showHelpDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'Pusat Bantuan',
      desc:
          'Butuh bantuan? Hubungi kami melalui email: support@hoomly.id\natau WhatsApp: +62 812-3456-7890',
      btnOkText: 'Mengerti',
      btnOkOnPress: () {},
      btnOkColor: AppTheme.primary,
    ).show();
  }

  void _showEditProfile(BuildContext context, UserProvider user) {
    final nameCtrl = TextEditingController(text: user.name);
    final emailCtrl = TextEditingController(text: user.email);
    final phoneCtrl = TextEditingController(text: user.phone);
    final addrCtrl = TextEditingController(text: user.address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ubah Profil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Lengkap')),
            const SizedBox(height: 10),
            TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Nomor Telepon')),
            const SizedBox(height: 10),
            TextField(
                controller: addrCtrl,
                decoration: const InputDecoration(labelText: 'Alamat')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.scale,
                      title: 'Data Tidak Lengkap',
                      desc: 'Nama dan email tidak boleh kosong.',
                      btnOkOnPress: () {},
                      btnOkColor: AppTheme.primary,
                    ).show();
                    return;
                  }
                  user.updateProfile(
                    name: nameCtrl.text,
                    email: emailCtrl.text,
                    phone: phoneCtrl.text,
                    address: addrCtrl.text,
                  );
                  Navigator.pop(context);
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.scale,
                    title: 'Profil Diperbarui!',
                    desc: 'Informasi profilmu berhasil disimpan.',
                    btnOkOnPress: () {},
                    btnOkColor: AppTheme.primary,
                  ).show();
                },
                child: const Text('Simpan Perubahan'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
