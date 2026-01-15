import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Halaman_Utama extends StatefulWidget {
  const Halaman_Utama({super.key});

  @override
  State<Halaman_Utama> createState() => _Halaman_UtamaState();
}

class _Halaman_UtamaState extends State<Halaman_Utama> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final List<String> _prodiList = ['Informatika', 'Mesin', 'Sipil', 'Arsitek'];
  final List<String> _kelasList = ['A', 'B', 'C', 'D', 'E'];
  String? _selectedKelas;
  String? _selectedProdi;
  String _jenisKelamin = 'Pria';

  List<Map<String, dynamic>> _items = [];
  static const String _prefsKey = 'submissions';

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _npmController.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? raw = prefs.getStringList(_prefsKey);
    if (raw != null) {
      setState(() {
        _items = raw.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
      });
    }
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = _items.map((m) => jsonEncode(m)).toList();
    await prefs.setStringList(_prefsKey, raw);
  }

  void _addOrUpdateItem() {
    final nama = _namaController.text.trim();
    final alamat = _alamatController.text.trim();
    final npm = _npmController.text.trim();

    if (nama.isEmpty || npm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan NPM wajib diisi')),
      );
      return;
    }

    if (_editingIndex == null) {
      // Tambah baru
      final item = {
        'nama': nama,
        'alamat': alamat,
        'npm': npm,
        'kelas': _selectedKelas ?? '-',
        'prodi': _selectedProdi ?? '-',
        'jk': _jenisKelamin,
        'createdAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        _items.insert(0, item);
      });

      _saveAll();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan')),
      );
    } else {
      final index = _editingIndex!;
      final oldCreatedAt = _items[index]['createdAt'] as String?;

      final updated = {
        'nama': nama,
        'alamat': alamat,
        'npm': npm,
        'kelas': _selectedKelas ?? '-',
        'prodi': _selectedProdi ?? '-',
        'jk': _jenisKelamin,
        'createdAt': oldCreatedAt ?? DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        _items[index] = updated;
        _editingIndex = null;
      });

      _saveAll();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui')),
      );
    }

    _clearForm();
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      _items.removeAt(index);
    });
    await _saveAll();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data dihapus')),
    );
  }

  void _startEdit(int index) {
    final item = _items[index];
    setState(() {
      _editingIndex = index;
      _namaController.text = item['nama'] ?? '';
      _alamatController.text = item['alamat'] ?? '';
      _npmController.text = item['npm'] ?? '';
      _selectedKelas =
      (item['kelas'] is String) ? item['kelas'] as String : null;
      _selectedProdi =
      (item['prodi'] is String) ? item['prodi'] as String : null;
      _jenisKelamin = (item['jk'] as String?) ?? 'Pria';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Mode edit: perbarui form lalu tekan Update')),
    );
  }

  void _clearForm() {
    _namaController.clear();
    _alamatController.clear();
    _npmController.clear();
    setState(() {
      _selectedKelas = null;
      _selectedProdi = null;
      _jenisKelamin = 'Pria';
      _editingIndex = null;
    });
  }

  void _showDetail(Map<String, dynamic> item, int index) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text('Detail'),
            content: Text(
              'Nama: ${item['nama'] ?? '-'}\n'
                  'Alamat: ${item['alamat'] ?? '-'}\n'
                  'NPM: ${item['npm'] ?? '-'}\n'
                  'Kelas: ${item['kelas'] ?? '-'}\n'
                  'Prodi: ${item['prodi'] ?? '-'}\n'
                  'Jenis Kelamin: ${item['jk'] ?? '-'}\n'
                  'Waktu dibuat: ${item['createdAt'] ?? '-'}\n'
                  'Waktu diperbarui: ${item['updatedAt'] ?? '-'}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startEdit(index);
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _removeItem(index);
                },
                child: const Text('Hapus'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tutup'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// ===== FORM CARD =====
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _alamatController,
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _npmController,
                        decoration: InputDecoration(
                          labelText: 'NPM',
                          prefixIcon: const Icon(Icons.badge),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedKelas,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Kelas',
                          prefixIcon: const Icon(Icons.class_),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _kelasList
                            .map((k) =>
                            DropdownMenuItem(
                              value: k,
                              child: Text(k),
                            ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedKelas = v),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedProdi,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Prodi',
                          prefixIcon: const Icon(Icons.school),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _prodiList
                            .map((p) =>
                            DropdownMenuItem(
                              value: p,
                              child: Text(p),
                            ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedProdi = v),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            'Jenis Kelamin:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Radio<String>(
                            value: 'Pria',
                            groupValue: _jenisKelamin,
                            onChanged: (v) =>
                                setState(() => _jenisKelamin = v!),
                          ),
                          const Text('Pria'),
                          Radio<String>(
                            value: 'Perempuan',
                            groupValue: _jenisKelamin,
                            onChanged: (v) =>
                                setState(() => _jenisKelamin = v!),
                          ),
                          const Text('Perempuan'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(
                                _editingIndex == null
                                    ? Icons.send
                                    : Icons.update,
                              ),
                              label: Text(
                                _editingIndex == null ? 'Submit' : 'Update',
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _addOrUpdateItem,
                            ),
                          ),
                          if (_editingIndex != null) ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: _clearForm,
                              child: const Text('Batal'),
                            ),
                          ]
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ===== LIST DATA =====
              Expanded(
                child: _items.isEmpty
                    ? const Center(
                  child: Text(
                    'Belum ada data',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Dismissible(
                      key: Key(item['createdAt'] ?? index.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _removeItem(index),
                      child: Card(
                        elevation: 6,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(item['nama'] ?? '-'),
                          subtitle: Text(
                              '${item['npm']} • ${item['prodi']}'),
                          trailing: Chip(
                            label: Text(item['kelas'] ?? '-'),
                          ),
                          onTap: () => _showDetail(item, index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

