import 'package:flutter/material.dart';
import 'owner_page.dart';
import 'dev_page.dart';
import 'partner_page.dart';
import 'pemula_page.dart';
import 'global_chat_page.dart'; 

class CustomDrawer extends StatelessWidget {
  final String username;
  final String role;
  final String sessionKey;

  const CustomDrawer({super.key, required this.username, required this.role, required this.sessionKey});

  @override
  Widget build(BuildContext context) {
    final userRole = role.toLowerCase();
    final isOwner = userRole == 'owner' || userRole == 'admin' || userRole == 'high_owner' || userRole == 'pemilik';
    final isDev = userRole == 'dev' || userRole == 'developer';
    final isPartner = userRole == 'partner';
    final isPemula = userRole == 'pemula';

    return Drawer(
      backgroundColor: const Color(0xFFEAF4FF),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: const BoxDecoration(color: Color(0xFF247BFF)),
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF171717), width: 2), boxShadow: const [BoxShadow(color: Color(0xFF171717), offset: Offset(3, 4), blurRadius: 0)]),
                  child: Center(child: Text(username.isNotEmpty ? username[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF247BFF)))),
                ),
                const SizedBox(height: 12),
                Text(username.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF171717), width: 1.5), borderRadius: BorderRadius.circular(4)),
                  child: Text(role.toUpperCase(), style: const TextStyle(color: Color(0xFFE53935), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                if (isOwner) _buildMenuItem(context, Icons.admin_panel_settings, 'Owner Page', onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerPage(sessionKey: sessionKey, username: username))); }),
                if (isDev) _buildMenuItem(context, Icons.code, 'Developer Page', onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => DevPage(sessionKey: sessionKey))); }),
                if (isPartner) _buildMenuItem(context, Icons.handshake, 'Partner Page', onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerPage(sessionKey: sessionKey, username: username))); }),
                if (isPemula) _buildMenuItem(context, Icons.manage_accounts, 'Pemula Page', onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => PemulaPage(sessionKey: sessionKey))); }),
                _buildMenuItem(context, Icons.forum, 'Public Chat', isBordered: true, onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(username: username))); }),
                _buildMenuItem(context, Icons.workspace_premium, 'Premium Users', isBordered: true),
                _buildMenuItem(context, Icons.music_note, 'Trapenden Music', isBordered: true),
                const SizedBox(height: 10),
                _buildMenuItem(context, Icons.monitor_heart, 'System Monitor'),
                _buildMenuItem(context, Icons.assignment, 'Activity Log'),
                _buildMenuItem(context, Icons.notifications, 'Notifications'),
                _buildMenuItem(context, Icons.security, 'Account Security'),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: Colors.black, thickness: 1.5)),
                _buildMenuItem(context, Icons.history, 'Riwayat Aktivitas'),
                _buildMenuItem(context, Icons.support_agent, 'Support'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), border: Border.all(color: const Color(0xFFE53935), width: 2), borderRadius: BorderRadius.circular(12)),
                child: const Row(children: [Icon(Icons.logout, color: Color(0xFFE53935), size: 20), SizedBox(width: 16), Text('Log Out', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w900, fontSize: 14, fontFamily: 'monospace')), Spacer(), Icon(Icons.arrow_forward_ios, color: Color(0xFFE53935), size: 14)]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, {bool isBordered = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap ?? () => Navigator.pop(context), 
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: isBordered ? BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF171717), width: 2), borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Color(0xFF171717), offset: Offset(2, 3), blurRadius: 0)]) : null,
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF171717), size: 22),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: const TextStyle(color: Color(0xFF171717), fontWeight: FontWeight.w800, fontSize: 14, fontFamily: 'monospace'))),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF171717), size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
