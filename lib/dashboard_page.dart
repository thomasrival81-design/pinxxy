import 'package:flutter/material.dart';
import 'bug_page.dart';       
import 'info_page.dart';      
import 'tools_gateway.dart';  
import 'custom_drawer.dart'; // <--- IMPORT DRAWER BARU LU

class DashboardPage extends StatefulWidget {
  final String username;
  final String password;
  final String role;
  final String expiredDate;
  final String sessionKey;
  final List<Map<String, dynamic>> listBug;
  final List<Map<String, dynamic>> listDoos;
  final List<dynamic> news;
  final String? uid;

  const DashboardPage({
    super.key,
    required this.username,
    required this.password,
    required this.role,
    required this.expiredDate,
    required this.listBug,
    required this.listDoos,
    required this.sessionKey,
    required this.news,
    this.uid,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color bg = Color(0xFFEAF4FF);
  static const Color blue = Color(0xFF247BFF);
  static const Color ink = Color(0xFF171717);
  static const Color muted = Color(0xFF687386);

  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem('BERANDA', Icons.home_rounded),
    _NavItem('BUG', Icons.bug_report_rounded),
    _NavItem('TOOLS', Icons.grid_view_rounded),
    _NavItem('ALAT', Icons.tune_rounded),
    _NavItem('INFO', Icons.info_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      // === TAMBAHIN DRAWER DI SINI ===
      drawer: CustomDrawer(
        username: widget.username,
        role: widget.role, // <--- WAJIB DIKIRIM BIAR MENU DINAMIS
        sessionKey: widget.sessionKey, // <--- WAJIB DIKIRIM
      ),
      // ===============================
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
                child: _selectedIndex == 0
                    ? _buildHome()
                    : _buildSection(_navItems[_selectedIndex]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomNavigation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // === TOMBOL KIRI ATAS BUKA DRAWER ===
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer(); 
              },
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.white, 
                  border: Border.all(color: ink, width: 2), 
                  borderRadius: BorderRadius.circular(15), 
                  boxShadow: const [BoxShadow(color: ink, offset: Offset(3, 4), blurRadius: 0)]
                ),
                child: const Icon(Icons.dashboard_rounded, color: blue, size: 27),
              ),
            ),
            // ===================================
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TRAPENDEN PROJECT', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  const SizedBox(height: 3),
                  Text('Halo, ${widget.username}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: blue, width: 1.5), borderRadius: BorderRadius.circular(30)),
              child: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.circle, color: Color(0xFF20B26B), size: 9), SizedBox(width: 6), Text('ONLINE', style: TextStyle(color: ink, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.7))]),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _outlinedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const [Icon(Icons.dashboard_customize_rounded, color: blue, size: 22), SizedBox(width: 9), Text('DASHBOARD', style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.3)), Spacer(), _StatusPill(label: 'ACTIVE')]),
              const SizedBox(height: 18),
              const Text('Selamat datang!', style: TextStyle(color: ink, fontSize: 23, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('Kelola fitur dan lihat ringkasan akun kamu dari satu tempat.', style: TextStyle(color: muted, fontSize: 13, height: 1.45)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _statCard(title: 'BUG TERSEDIA', value: '${widget.listBug.length}', icon: Icons.bug_report_rounded)),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard(title: 'TOOLS', value: '${widget.listDoos.length}', icon: Icons.build_circle_rounded)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _statCard(title: 'TOTAL NEWS', value: '${widget.news.length}', icon: Icons.newspaper_rounded)),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard(title: 'TOTAL USERS', value: '—', icon: Icons.groups_rounded, subtitle: 'Data server belum tersedia')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _outlinedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const [Icon(Icons.person_rounded, color: blue, size: 22), SizedBox(width: 9), Text('INFORMASI AKUN', style: TextStyle(color: ink, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.8))]),
              const SizedBox(height: 16),
              _infoRow(Icons.person_outline_rounded, 'Username', widget.username),
              _infoRow(Icons.verified_user_outlined, 'Role', widget.role),
              _infoRow(Icons.event_available_rounded, 'Masa aktif', widget.expiredDate),
              if ((widget.uid ?? '').isNotEmpty) _infoRow(Icons.fingerprint_rounded, 'UID', widget.uid!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(_NavItem item) {
    if (_selectedIndex == 1) {
      return BugPage(
        username: widget.username,
        role: widget.role,
        expiredDate: widget.expiredDate,
        sessionKey: widget.sessionKey,
      );
    }
    if (_selectedIndex == 2) {
      return ToolsPage(
        sessionKey: widget.sessionKey,
        userRole: widget.role, 
        listDoos: widget.listDoos, 
      );
    }
    if (_selectedIndex == 3) {
      return const Center(child: Text('Halaman Alat Belum Disambungkan', style: TextStyle(color: Colors.black)));
    }
    if (_selectedIndex == 4) {
      return InfoPage(
        sessionKey: widget.sessionKey, 
      );
    }
    return const Center(child: Text('Halaman tidak ditemukan'));
  }

  Widget _outlinedCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23), border: Border.all(color: ink, width: 2), boxShadow: const [BoxShadow(color: ink, offset: Offset(4, 6), blurRadius: 0)]),
      child: child,
    );
  }

  Widget _statCard({required String title, required String value, required IconData icon, String? subtitle}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8FBFF), border: Border.all(color: const Color(0xFFD4E5FF), width: 1.4), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: blue, size: 22),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: ink, fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: muted, fontSize: 9))],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(icon, color: blue, size: 19),
          const SizedBox(width: 10),
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: muted, fontSize: 12))),
          const Text(': ', style: TextStyle(color: muted)),
          Expanded(child: Text(value.isEmpty ? '-' : value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: ink, width: 2), boxShadow: const [BoxShadow(color: ink, offset: Offset(4, 5), blurRadius: 0)]),
      child: Row(
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          final active = index == _selectedIndex;
          return Expanded(
            child: Semantics(
              button: true,
              selected: active,
              label: item.label,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => setState(() => _selectedIndex = index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: active ? 45 : 38, height: active ? 45 : 38,
                        decoration: BoxDecoration(color: active ? blue : Colors.transparent, shape: BoxShape.circle, border: active ? Border.all(color: ink, width: 1.5) : null, boxShadow: active ? const [BoxShadow(color: ink, offset: Offset(2, 3), blurRadius: 0)] : null),
                        child: Icon(item.icon, size: active ? 23 : 21, color: active ? Colors.white : muted),
                      ),
                      const SizedBox(height: 5),
                      Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: active ? blue : muted, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.25)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  const _NavItem(this.label, this.icon);
}

class _StatusPill extends StatelessWidget {
  final String label;
  const _StatusPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFEAF4FF), border: Border.all(color: const Color(0xFF247BFF), width: 1.2), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: Color(0xFF247BFF), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
    );
  }
}