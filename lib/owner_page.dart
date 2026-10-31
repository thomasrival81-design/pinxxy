import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/custom_popup.dart';

class OwnerPage extends StatefulWidget {
  final String sessionKey;
  final String username;

  const OwnerPage({
    super.key,
    required this.sessionKey,
    required this.username,
  });

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  // === WARNA TEMA BARU ===
  static const Color bg = Color(0xFFEAF4FF);
  static const Color blue = Color(0xFF247BFF);
  static const Color ink = Color(0xFF171717);
  static const Color muted = Color(0xFF687386);
  static const Color red = Color(0xFFE53935);
  static const Color gold = Color(0xFFFFC107);

  // === STATE & CONTROLLER ===
  late String sessionKey;
  List<dynamic> fullUserList = [];
  List<dynamic> filteredList = [];
  
  final List<String> roleOptions = ['pahari', 'full up', 'reseller', 'vip', 'pt', 'tk'];
  String selectedRole = 'pahari';
  String selectedRoleList = 'pahari';

  bool isLoading = false;

  // Controllers
  final createUsernameController = TextEditingController();
  final createPasswordController = TextEditingController();
  final createDayController = TextEditingController();
  final deleteController = TextEditingController();
  final editUsernameController = TextEditingController();
  final editDayController = TextEditingController();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sessionKey = widget.sessionKey;
    _fetchUsers();
  }

  // === LOGIKA API (TETAP SAMA SEPERTI ASLINYA) ===
  Future<void> _fetchUsers() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse('http://zamnode.myserverr.web.id:2065/listUsers?key=$sessionKey'));
      final data = jsonDecode(res.body);
      if (data['valid'] == true && data['authorized'] == true) {
        fullUserList = data['users'] ?? [];
        _filterList();
      } else {
        _alert("Info", data['message'] ?? 'Gagal memuat user.');
      }
    } catch (_) {
      _alert("Error", "Gagal terhubung ke server.");
    }
    setState(() => isLoading = false);
  }

  void _filterList() {
    setState(() {
      filteredList = fullUserList.where((u) {
        final uRole = u['role'].toString().toLowerCase();
        final isSearchMatch = u['username'].toString().toLowerCase().contains(searchController.text.toLowerCase());
        return uRole == selectedRoleList && isSearchMatch;
      }).toList();
    });
  }

  Future<void> _deleteUser() async {
    final username = deleteController.text.trim();
    if (username.isEmpty) return _alert("Peringatan", "Masukkan username!");
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse('http://zamnode.myserverr.web.id:2065/deleteUser?key=$sessionKey&username=$username'));
      final data = jsonDecode(res.body);
      if (data['deleted'] == true) {
        _alert("Sukses", "User berhasil dihapus.");
        deleteController.clear();
        _fetchUsers();
      } else {
        _alert("Gagal", data['message'] ?? 'Gagal menghapus user.');
      }
    } catch (_) { _alert("Error", "Gagal menghubungi server."); }
    setState(() => isLoading = false);
  }

  Future<void> _createAccount() async {
    final u = createUsernameController.text.trim();
    final p = createPasswordController.text.trim();
    final d = createDayController.text.trim();
    if (u.isEmpty || p.isEmpty || d.isEmpty) return _alert("Peringatan", "Semua field wajib diisi!");
    
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('http://zamnode.myserverr.web.id:2065/userAdd?key=$sessionKey&username=$u&password=$p&day=$d&role=$selectedRole');
      final res = await http.get(url);
      final data = jsonDecode(res.body);
      if (data['created'] == true) {
        _alert("Sukses", "Akun berhasil dibuat!");
        createUsernameController.clear();
        createPasswordController.clear();
        createDayController.clear();
        _fetchUsers();
      } else {
        _alert("Gagal", data['message'] ?? 'Gagal membuat akun.');
      }
    } catch (_) { _alert("Error", "Gagal menghubungi server."); }
    setState(() => isLoading = false);
  }

  Future<void> _editUser() async {
    final u = editUsernameController.text.trim();
    final d = editDayController.text.trim();
    if (u.isEmpty || d.isEmpty) return _alert("Peringatan", "Isi username dan durasi!");
    
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('http://zamnode.myserverr.web.id:2065/editUser?key=$sessionKey&username=$u&addDays=$d');
      final res = await http.get(url);
      final data = jsonDecode(res.body);
      if (data['edited'] == true) {
        _alert("Sukses", "Durasi berhasil diperbarui.");
        editUsernameController.clear();
        editDayController.clear();
        _fetchUsers();
      } else {
        _alert("Gagal", data['message'] ?? 'Gagal mengubah durasi.');
      }
    } catch (_) { _alert("Error", "Gagal menghubungi server."); }
    setState(() => isLoading = false);
  }

  void _alert(String title, String message) {
    CustomPopup.show(context, title: title, message: message, icon: title.toLowerCase().contains("sukses") ? Icons.check_circle : Icons.info);
  }

  // === WIDGET UI ===
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('OWNER PANEL', style: TextStyle(color: ink, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        centerTitle: true,
      ),
      body: isLoading && fullUserList.isEmpty
          ? const Center(child: CircularProgressIndicator(color: blue))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPenghasilanCard(),
                const SizedBox(height: 16),
                _buildDeleteUserCard(),
                const SizedBox(height: 16),
                _buildCreateAccountCard(),
                const SizedBox(height: 16),
                _buildExtendDurationCard(),
                const SizedBox(height: 16),
                _buildUserListCard(),
                const SizedBox(height: 16),
                _buildStoreFooter(),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildPenghasilanCard() {
    return _outlinedCard(
      color: const Color(0xFF0F172A), // Navy gelap
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.monetization_on, color: gold),
                  SizedBox(width: 8),
                  Text('PENGHASILAN OWNER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(4)),
                child: const Text('TIDAK BISA DITARIK', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text('Rp 🚫', style: TextStyle(color: gold, fontSize: 40, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Total pendapatan dari penjualan akun', style: TextStyle(color: Colors.white54, fontSize: 12)),
          const Divider(color: Colors.white24, height: 30),
          _buildIncomeRow('Pahari (Rp 5.000)', 'Rp 0', gold),
          _buildIncomeRow('Full Up (Rp 30.000)', 'Rp 0', Colors.purpleAccent),
          _buildIncomeRow('Reseller (Rp 50.000)', 'Rp 0', blue),
          _buildIncomeRow('VIP (Rp 60.000)', 'Rp 0', Colors.orange),
          _buildIncomeRow('PT (Rp 80.000)', 'Rp 0', Colors.green),
          _buildIncomeRow('TK (Rp 100.000)', 'Rp 0', Colors.pinkAccent),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.money_off, color: red),
              label: const Text('TARIK PENGHASILAN', style: TextStyle(color: red, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIncomeRow(String label, String value, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.circle, color: dotColor, size: 10),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13))),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildDeleteUserCard() {
    return _outlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.person_off, 'DELETE USER'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: red), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.security, color: red, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('Role HIGH_OWNER / OWNER / PEMILIK / DEVELOPER / FOUNDER tidak dapat dihapus.', style: TextStyle(color: red, fontSize: 11, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildInput('Username Target', deleteController, Icons.person),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _deleteUser,
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text('DELETE ACCOUNT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCreateAccountCard() {
    return _outlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.person_add, 'REQUEST CREATE ACCOUNT'),
          const SizedBox(height: 16),
          _buildInput('Username', createUsernameController, Icons.person),
          const SizedBox(height: 12),
          _buildInput('Password', createPasswordController, Icons.lock),
          const SizedBox(height: 12),
          _buildInput('Durasi (Hari)', createDayController, Icons.calendar_today, isNumber: true),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(12), border: Border.all(color: ink, width: 2)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down, color: blue),
                items: roleOptions.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: ink)))).toList(),
                onChanged: (v) => setState(() => selectedRole = v!),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Upload Bukti Transfer Mockup (Sesuai UI)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(12), border: Border.all(color: ink, width: 2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.attach_file, color: blue, size: 16),
                    SizedBox(width: 4),
                    Text('BUKTI TRANSAKSI', style: TextStyle(fontWeight: FontWeight.bold, color: ink)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Upload screenshot pembayaran', style: TextStyle(color: muted, fontSize: 11)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: muted.withOpacity(0.5))),
                  child: const Column(
                    children: [
                      Icon(Icons.cloud_upload, color: blue, size: 30),
                      SizedBox(height: 8),
                      Text('Upload Bukti Transfer', style: TextStyle(color: blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _createAccount,
              icon: const Icon(Icons.cloud_upload, color: Colors.white),
              label: const Text('REQUEST CREATE ACCOUNT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: blue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExtendDurationCard() {
    return _outlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.access_time, 'EXTEND DURATION'),
          const SizedBox(height: 16),
          _buildInput('Username Target', editUsernameController, Icons.person_search),
          const SizedBox(height: 12),
          const Text('⚡ QUICK PRESET', style: TextStyle(color: blue, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _quickPreset('+7D', 7),
              const SizedBox(width: 8),
              _quickPreset('+30D', 30),
              const SizedBox(width: 8),
              _quickPreset('+60D', 60),
              const SizedBox(width: 8),
              _quickPreset('+90D', 90),
            ],
          ),
          const SizedBox(height: 12),
          _buildInput('Tambah Hari (manual)', editDayController, Icons.calendar_today, isNumber: true),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _editUser,
              icon: const Icon(Icons.calendar_month, color: Colors.white),
              label: const Text('ADD DAYS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: blue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          )
        ],
      ),
    );
  }

  Widget _quickPreset(String label, int days) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => editDayController.text = days.toString()),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: ink, width: 2), borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: ink, offset: Offset(2, 2), blurRadius: 0)]),
          child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: ink))),
        ),
      ),
    );
  }

  Widget _buildUserListCard() {
    return _outlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.people, 'USER LIST'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFFF8E1), border: Border.all(color: gold), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.security, color: gold, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('Role HIGH_OWNER / OWNER / PEMILIK / DEVELOPER / FOUNDER disembunyikan.', style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(12), border: Border.all(color: ink, width: 2)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedRoleList,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down, color: blue),
                items: roleOptions.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: ink)))).toList(),
                onChanged: (v) {
                  setState(() => selectedRoleList = v!);
                  _filterList();
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.copy_all, size: 16),
                  label: const Text('COPY ALL'),
                  style: OutlinedButton.styleFrom(foregroundColor: blue, side: const BorderSide(color: blue, width: 2), padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload, size: 16, color: Colors.white),
                  label: const Text('EXPORT', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: blue, padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: searchController,
            onChanged: (v) => _filterList(),
            decoration: InputDecoration(
              hintText: 'Cari username...',
              prefixIcon: const Icon(Icons.search, color: blue),
              filled: true,
              fillColor: const Color(0xFFF8FBFF),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ink, width: 2)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ink, width: 2)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: blue, width: 2)),
            ),
          ),
          const SizedBox(height: 16),
          if (filteredList.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('// tidak ada user', style: TextStyle(color: muted, fontFamily: 'monospace')),
              ),
            )
          else
            ...filteredList.map((u) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: ink, width: 1.5), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.person, color: blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u['username'], style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
                        Text('EXP: ${u['expiredDate']}', style: const TextStyle(fontSize: 11, color: muted)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.delete, color: red), onPressed: () {
                    deleteController.text = u['username'];
                    _deleteUser();
                  }),
                ],
              ),
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildStoreFooter() {
    return _outlinedCard(
      child: Column(
        children: [
          const Text('TRAPENDEN STORE', style: TextStyle(color: ink, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, color: blue, size: 16),
              const SizedBox(width: 8),
              Text('Owner: @nyalib', style: TextStyle(color: ink, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.code, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text('Developer: @herstore188', style: TextStyle(color: ink, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // === HELPER WIDGETS ===
  Widget _outlinedCard({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ink, width: 2),
        boxShadow: const [BoxShadow(color: ink, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: child,
    );
  }

  Widget _buildCardHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFE8F1FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: ink, width: 1.5)),
          child: Icon(icon, color: blue, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(color: ink, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: ink, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: muted, fontSize: 13),
        prefixIcon: Icon(icon, color: blue, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FBFF),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ink, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ink, width: 2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: blue, width: 2)),
      ),
    );
  }
}