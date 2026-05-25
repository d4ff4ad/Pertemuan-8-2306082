# Pertemuan 8 - Consume API & State Management Provider

Aplikasi Flutter ini adalah proyek praktikum untuk mendemonstrasikan konsumsi API (*Application Programming Interface*) menggunakan package `http` dan penerapan manajemen state menggunakan package `provider`.

---

## 🚀 Fitur Utama

- **Daftar Postingan**: Mengambil dan menampilkan data teks dari API [JSONPlaceholder](https://jsonplaceholder.typicode.com/).
- **Daftar Foto**: Mengambil dan menampilkan data gambar serta informasi pembuatnya dari API [Picsum Photos](https://picsum.photos/).
- **Manajemen State (Provider)**: Memisahkan logika pengambilan data (bisnis) dari tampilan (UI) untuk menjaga kode tetap bersih, terstruktur, dan mudah dikelola.

---

## 📂 Struktur Proyek

Berikut adalah struktur folder utama dari aplikasi ini setelah dilakukan refaktorisasi menggunakan Provider:

```text
lib/
├── models/
│   ├── photo_model.dart       # Model data untuk Foto (JSON serialization)
│   └── post_model.dart        # Model data untuk Postingan (JSON serialization)
├── providers/
│   ├── photo_provider.dart    # State Management & logika fetching untuk Foto
│   └── post_provider.dart     # State Management & logika fetching untuk Postingan
├── services/
│   ├── photo_service.dart     # Service pemanggilan API Picsum
│   └── post_service.dart      # Service pemanggilan API JSONPlaceholder
├── main.dart                  # Titik masuk aplikasi (registrasi MultiProvider)
├── photos.dart                # Tampilan halaman Foto
└── post.dart                  # Hampilan halaman Postingan (Home)
```

---

## 🛠️ Penjelasan Kode & Penerapan Provider

Sebelumnya, aplikasi ini menggunakan `FutureBuilder` langsung di dalam UI untuk memanggil API. Hal ini kurang efisien karena data akan di-request ulang setiap kali widget di-rebuild. Sekarang, aplikasi menggunakan arsitektur **Provider**:

### 1. Provider Class (State & Business Logic)
Kami membuat kelas Provider (`ChangeNotifier`) untuk menampung data, status loading, dan pesan kesalahan. Contoh pada `PostProvider`:

```dart
class PostProvider with ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Memberi tahu UI untuk menampilkan loading spinner

    try {
      _posts = await PostService.getPosts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Memberi tahu UI untuk memperbarui data / menampilkan error
    }
  }
}
```

### 2. Registrasi Provider di `main.dart`
Agar provider dapat diakses di seluruh aplikasi, kita mendaftarkannya menggunakan `MultiProvider` di file `lib/main.dart`:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 3. Mengonsumsi State di Halaman UI
Di dalam halaman UI (`PostPage` & `PhotoPage`), kita menggunakan `Consumer` untuk memantau perubahan state secara real-time dan membangun UI yang sesuai:

- Pengambilan data dipicu sekali di `initState()` menggunakan `Future.microtask` untuk menghindari pemanggilan berulang saat rebuild.
- `Consumer` akan secara otomatis mengganti tampilan menjadi spinner pemuatan data (`CircularProgressIndicator`), pesan error jika gagal, atau menampilkan daftar data dalam bentuk `ListView`.

```dart
Consumer<PostProvider>(
  builder: (context, postProvider, child) {
    if (postProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (postProvider.errorMessage.isNotEmpty) {
      return Center(child: Text('Error: ${postProvider.errorMessage}'));
    }
    // Render ListView...
  }
)
```

---

## ⚙️ Persyaratan & Cara Menjalankan

### Persyaratan
- Flutter SDK `^3.10.0`
- Dart SDK `^3.10.0`

### Langkah Menjalankan
1. Klon repository ini (jika belum).
2. Jalankan perintah untuk mengunduh dependensi:
   ```bash
   flutter pub get
   ```
3. Hubungkan perangkat emulator atau fisik Anda.
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```
