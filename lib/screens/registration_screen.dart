import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender; // Latihan 3
  String _passwordStrength = ''; // Latihan 5

  double _passwordStrengthValue = 0.0; // Latihan 5
  Color _passwordStrengthColor = Colors.transparent; // Latihan 5

  bool _isTermsAccepted = false; // Latihan 4
  bool _showTermsError = false; // Latihan 4
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose(); // Tambahan Latihan 1
    _dobController.dispose(); // Tambahan Latihan 2
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validasi nama
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  // Validasi konfirmasi password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Latihan 1: Validasi nomor telepon
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Nomor telepon hanya boleh berisi angka';
    }
    if (value.trim().length < 10 || value.trim().length > 13) {
      return 'Nomor telepon harus antara 10 hingga 13 digit';
    }
    return null;
  }

  // Validasi tanggal lahir
  String? _validateDob(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tanggal lahir wajib diisi';
    }
    return null;
  }

  // Latihan 3: Validasi Dropdown Jenis Kelamin
  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jenis kelamin wajib dipilih';
    }
    return null;
  }

  // Latihan 2: Fungsi untuk menampilkan DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
  );

  if (picked != null && picked != _selectedDate) {
    // Sesuai prinsip least privilege, setState hanya memperbarui state Latihan 2
    setState(() {
      _selectedDate = picked;
      // Memformat tanggal untuk ditampilkan di TextFormField
      _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
    });
  }
}

  // Handler submit form
  void _submitForm() {
  // Latihan 4: Update state error untuk checkbox HANYA JIKA belum dicentang
  setState(() {
    _showTermsError = !_isTermsAccepted;
  });

  if (_formKey.currentState!.validate() && _isTermsAccepted) {
    setState(() {
      _isLoading = true;
    });

    // Simulasi proses registrasi (kode Anda sebelumnya tetap sama)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registrasi Berhasil'),
          content: Text(
              'Selamat, ${_nameController.text}!\nEmail: ${_emailController.text}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}

  // Reset form
  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear(); // Tambahan Latihan 1
    _dobController.clear(); // Tambahan Latihan 2
    _passwordController.clear();
    _confirmPasswordController.clear();

    setState(() {
      _selectedDate = null;
      _selectedGender = null; // Latihan 3
      _isTermsAccepted = false; // Latihan 4
      _showTermsError = false; // Latihan 4

      _passwordStrength = ''; // Latihan 5
      _passwordStrengthValue = 0.0; // Latihan 5
      _passwordStrengthColor = Colors.transparent; // Latihan 5
    });
  }

  // Latihan 5: Logika pengecekan kekuatan password
  void _checkPasswordStrength(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordStrength = '';
        _passwordStrengthValue = 0.0;
        _passwordStrengthColor = Colors.transparent;
      } else if (value.length < 8) {
        _passwordStrength = 'Lemah';
        _passwordStrengthValue = 0.33;
        _passwordStrengthColor = Colors.red;
      } else {
        // Panjang sudah >= 8 karakter
        bool hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
        bool hasLowercase = RegExp(r'[a-z]').hasMatch(value);
        bool hasDigits = RegExp(r'[0-9]').hasMatch(value);
        bool hasSymbols = RegExp(r'[!@#\$&*~_.]').hasMatch(value);
        bool hasLetters = RegExp(r'[a-zA-Z]').hasMatch(value);

        if (hasUppercase && hasLowercase && hasDigits && hasSymbols) {
          _passwordStrength = 'Kuat';
          _passwordStrengthValue = 1.0;
          _passwordStrengthColor = Colors.green;
        } else if (hasLetters && hasDigits) {
          _passwordStrength = 'Sedang';
          _passwordStrengthValue = 0.66;
          _passwordStrengthColor = Colors.orange;
        } else {
          _passwordStrength = 'Lemah';
          _passwordStrengthValue = 0.33;
          _passwordStrengthColor = Colors.red;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const SizedBox(height: 16),
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Isi form di bawah ini untuk mendaftar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Field Nama
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),

                // Field Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                // Field Nomor Telepon (Latihan 1)
                CustomTextField(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  hint: 'Masukkan nomor telepon (10-13 digit)',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),

                // Field Tanggal Lahir (Latihan 2)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _dobController,
                    readOnly: true, // Membuat field tidak bisa diketik manual
                    onTap: () => _selectDate(context), // Memanggil showDatePicker saat di-tap
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir',
                      hintText: 'Pilih tanggal lahir Anda',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: _validateDob,
                  ),
                ),

                // Field Jenis Kelamin (Latihan 3)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Jenis Kelamin',
                      prefixIcon: const Icon(Icons.people),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    value: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (value) {
                      // Least privilege: hanya merender ulang jika dropdown diubah
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: _validateGender,
                  ),
                ),

                // Checkbox Syarat & Ketentuan (Latihan 4)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        title: const Text('Saya setuju dengan Syarat & Ketentuan'),
                        value: _isTermsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _isTermsAccepted = value ?? false;
                            if (_isTermsAccepted) {
                              _showTermsError = false; // Hilangkan error otomatis saat dicentang
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, // Letakkan kotak di kiri
                        contentPadding: EdgeInsets.zero, // Hilangkan padding bawaan agar sejajar
                        activeColor: Colors.deepPurple,
                      ),
                      // Pesan error kustom untuk Checkbox
                      if (_showTermsError)
                        const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            'Syarat & Ketentuan wajib disetujui',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),

                // Field Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    onChanged: _checkPasswordStrength, // Tambahan Latihan 5: Memanggil fungsi saat diketik
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Minimal 8 karakter, huruf kapital, angka',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      border: const OutlineInputBorder(),
                      fillColor: Colors.grey[50],
                    ),
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                  ),
                ),

                // Indikator Kekuatan Password (Latihan 5)
                if (_passwordStrength.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _passwordStrengthValue,
                            backgroundColor: Colors.grey[300],
                            color: _passwordStrengthColor,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(10), // Membulatkan ujung bar
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 60, // Fixed width agar bar tidak melompat saat teks berubah
                          child: Text(
                            _passwordStrength,
                            style: TextStyle(
                              color: _passwordStrengthColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Field Konfirmasi Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Ulangi password Anda',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Daftar',
                          style: TextStyle(fontSize: 16),
                        ),
                ),

                const SizedBox(height: 12),

                // Tombol Reset
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}