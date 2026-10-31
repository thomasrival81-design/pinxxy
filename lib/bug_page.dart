import 'package:flutter/material.dart';
import 'bug_sender.dart'; // IMPORT FILE SENDER LU

class BugPage extends StatefulWidget {
  final String username;
  final String role;
  final String expiredDate;
  final String sessionKey;

  const BugPage({
    super.key,
    required this.username,
    required this.role,
    required this.expiredDate,
    required this.sessionKey,
  });

  @override
  State<BugPage> createState() => _BugPageState();
}

class _BugPageState extends State<BugPage> {
  static const Color bg = Color(0xFFEAF4FF);
  static const Color blue = Color(0xFF247BFF);
  static const Color ink = Color(0xFF171717);
  static const Color muted = Color(0xFF687386);
  static const Color green = Color(0xFF20B26B);
  static const Color red = Color(0xFFE53935);

  int _selectedPayload = 0;
  bool _isPrivateSender = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildVideoPreview(),
              const SizedBox(height: 16),
              _buildBugAttackHeader(),
              const SizedBox(height: 16),
              _buildTargetInput(),
              const SizedBox(height: 16),
              _buildPayloadList(),
              const SizedBox(height: 16),
              _buildSenderType(),
              const SizedBox(height: 16),
              _buildMonitorSystem(),
              const SizedBox(height: 16),
              _buildAccountSecurity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return _outlinedCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border.all(color: ink, width: 2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.menu, color: ink),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo ${widget.username} 👋', style: const TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: red, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('${widget.role} | Exp: ${widget.expiredDate}', style: const TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          _iconButton(Icons.qr_code_scanner),
          const SizedBox(width: 8),
          _iconButton(Icons.headset_mic),
          const SizedBox(width: 8),
          _iconButton(Icons.person_outline),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: ink, width: 2), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: ink, size: 20),
    );
  }

  Widget _buildVideoPreview() {
    return _outlinedCard(
      padding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(height: 180, width: double.infinity, color: Colors.black, child: const Center(child: Text('VIDEO PREVIEW AREA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ),
          Positioned(
            top: 10, left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: const Row(children: [Icon(Icons.circle, color: red, size: 10), SizedBox(width: 4), Text('LIVE', style: TextStyle(color: ink, fontSize: 10, fontWeight: FontWeight.bold))]),
            ),
          ),
          const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
        ],
      ),
    );
  }

  Widget _buildBugAttackHeader() {
    return _outlinedCard(
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: ink, width: 2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.bug_report, color: ink)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BUG ATTACK', style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 2),
                Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: red, shape: BoxShape.circle)), const SizedBox(width: 4), const Text('OWNER', style: TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(border: Border.all(color: ink, width: 2), borderRadius: BorderRadius.circular(8)), child: const Row(children: [Icon(Icons.flash_on, size: 14, color: ink), SizedBox(width: 4), Text('COMBO OFF', style: TextStyle(color: ink, fontSize: 10, fontWeight: FontWeight.bold))])),
        ],
      ),
    );
  }

  Widget _buildTargetInput() {
    return _outlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_android, color: ink),
              const SizedBox(width: 8),
              const Text('NOMOR TARGET', style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
              const Spacer(),
              TextButton(onPressed: (){}, child: const Text('PASTE')),
              Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: ink), borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.copy, size: 16)),
              const SizedBox(width: 4),
              Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: ink), borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.close, size: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(border: Border.all(color: ink, width: 2), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: const BoxDecoration(border: Border(right: BorderSide(color: ink, width: 2))),
                  child: const Row(children: [Text('🇮🇩', style: TextStyle(fontSize: 16)), SizedBox(width: 4), Text('+62', style: TextStyle(color: ink, fontWeight: FontWeight.bold)), Icon(Icons.arrow_drop_down, color: ink)]),
                ),
                const Expanded(child: TextField(decoration: InputDecoration(hintText: '81234567890', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12)), style: TextStyle(color: ink, fontWeight: FontWeight.bold, letterSpacing: 1))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayloadList() {
    final payloads = ['COMBO CRASH & BLANK...', 'LOCK CHAT', 'FC IOS NEW', 'BULLDOZER'];
    return _outlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(border: Border.all(color: ink), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.settings, size: 18)),
              const SizedBox(width: 8),
              const Text('BUG TYPE / PAYLOAD', style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(border: Border.all(color: ink), borderRadius: BorderRadius.circular(6)), child: const Text('6', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(payloads.length, (index) {
            final isSelected = _selectedPayload == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedPayload = index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(color: isSelected ? const Color(0xFFEAF4FF) : Colors.white, border: Border.all(color: isSelected ? blue : ink, width: 2), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? blue : muted, size: 18),
                    const SizedBox(width: 12),
                    Expanded(child: Text('[ ${payloads[index]} ]', style: TextStyle(color: ink, fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal))),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _buildSenderType() {
    return _outlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.storage, color: ink), SizedBox(width: 8), Text('SENDER TYPE', style: TextStyle(color: ink, fontWeight: FontWeight.w900))]),
          const SizedBox(height: 12),
          const Text('Pilih sumber nomor pengirim', style: TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _senderCard(title: 'Global', subtitle: '0 sender', isActive: !_isPrivateSender, onTap: () => setState(() => _isPrivateSender = false))),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // ==========================================
                    // NAH INI DIA NYAMBUNGIN KE BUG_SENDER.DART
                    // ==========================================
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BugSenderPage( // Pastiin nama class di bug_sender.dart ini!
                          username: widget.username,
                          sessionKey: widget.sessionKey,
                          role: widget.role,
                          // tambahin parameter lain kalau butuh
                        ),
                      ),
                    );
                  },
                  child: _senderCard(title: 'Private', subtitle: 'Session lu sendiri', isActive: _isPrivateSender, onTap: null),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _senderCard({required String title, required String subtitle, required bool isActive, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: isActive ? const Color(0xFFEAF4FF) : Colors.white, border: Border.all(color: isActive ? blue : ink, width: 2), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: isActive ? blue : Colors.transparent, shape: BoxShape.circle, border: isActive ? null : Border.all(color: ink, width: 2)),
              child: Icon(title == 'Global' ? Icons.language : Icons.person, color: isActive ? Colors.white : ink),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: muted, fontSize: 10)),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isActive ? green : Colors.grey, borderRadius: BorderRadius.circular(4)), child: Text(isActive ? 'ACTIVE' : '0/15', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitorSystem() {
    return _outlinedCard(
      child: Column(
        children: [
          const Row(children: [Icon(Icons.monitor_heart, color: ink), SizedBox(width: 8), Text('SYSTEM MONITOR', style: TextStyle(color: ink, fontWeight: FontWeight.w900)), Spacer(), Text('DEMO', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 16),
          _monitorBar('CPU', 0.48, green),
          const SizedBox(height: 8),
          _monitorBar('RAM', 0.42, blue),
          const SizedBox(height: 8),
          _monitorBar('NET', 0.07, Colors.purple),
        ],
      ),
    );
  }

  Widget _monitorBar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 40, child: Text(label, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.bold))),
        Expanded(child: LinearProgressIndicator(value: value, color: color, backgroundColor: Colors.grey[300], minHeight: 8)),
        const SizedBox(width: 10),
        Text('${(value * 100).toInt()}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAccountSecurity() {
    return _outlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.security, color: ink), SizedBox(width: 8), Text('ACCOUNT SECURITY', style: TextStyle(color: ink, fontWeight: FontWeight.w900))]),
          const SizedBox(height: 16),
          _securityRow('Session Status', 'VALID', green),
          _securityRow('Role Access', widget.role.toUpperCase(), red),
          _securityRow('Global Sender', 'ENABLED', green),
          _securityRow('Combo Bug', 'UNLOCKED (8)', blue),
          _securityRow('Daily Limit', '0 / 15', green),
          _securityRow('Expired', widget.expiredDate, green),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.share, size: 16), label: const Text('SHARE SESSION'), style: ElevatedButton.styleFrom(backgroundColor: blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.logout, size: 16), label: const Text('LOGOUT'), style: OutlinedButton.styleFrom(foregroundColor: ink, side: const BorderSide(color: ink, width: 2), padding: const EdgeInsets.symmetric(vertical: 12)))),
            ],
          )
        ],
      ),
    );
  }

  Widget _securityRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: muted, fontSize: 13)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(4)), child: Text(value, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _outlinedCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: ink, width: 2), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: ink, offset: Offset(4, 4), blurRadius: 0)]),
      child: child,
    );
  }
}