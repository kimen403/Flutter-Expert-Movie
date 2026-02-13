# SSL Pinning Implementation

## Overview
SSL Pinning telah diimplementasikan pada aplikasi Ditonton untuk menambah lapisan keamanan tambahan saat mengakses API TMDB. Implementasi ini memastikan bahwa aplikasi hanya akan berkomunikasi dengan server yang memiliki sertifikat SSL yang valid dan telah diverifikasi.

## Komponen yang Diimplementasikan

### 1. Sertifikat SSL
**File**: `certificates/tmdb.pem`
- Sertifikat SSL dari domain `api.themoviedb.org`
- Format: PEM (Privacy-Enhanced Mail)
- Validitas: Sertifikat valid dari DigiCert Global G2 TLS RSA SHA256 2020 CA1

### 2. SSL Pinning Helper
**File**: `lib/common/ssl_pinning.dart`

Helper class yang mengelola HTTP client dengan SSL pinning:
```dart
class SSLPinningHelper {
  static Future<http.Client> get client async
}
```

**Fitur:**
- Singleton pattern untuk efficiency
- Load sertifikat dari assets
- Konfigurasi SecurityContext dengan trusted certificates
- Bad certificate callback untuk validasi strict

### 3. Dependency Injection
**File**: `lib/injection.dart`

HTTP Client telah diupdate untuk menggunakan SSL Pinning:
```dart
locator.registerLazySingletonAsync<http.Client>(
  () async => await SSLPinningHelper.client,
);
```

### 4. Exception & Failure Handling

**Exception baru** (`lib/common/exception.dart`):
```dart
class SSLException implements Exception {
  final String message;
  SSLException(this.message);
}
```

**Failure baru** (`lib/common/failure.dart`):
```dart
class SSLFailure extends Failure {
  SSLFailure(String message) : super(message);
}
```

### 5. Repository Updates

**Movie Repository** (`lib/data/repositories/movie_repository_impl.dart`):
- Semua method yang mengakses remote data source telah ditambahkan SSL exception handling
- Methods: `getNowPlayingMovies`, `getMovieDetail`, `getMovieRecommendations`, `getPopularMovies`, `getTopRatedMovies`, `searchMovies`

**TV Series Repository** (`lib/data/repositories/tv_series_repository_impl.dart`):
- Semua method yang mengakses remote data source telah ditambahkan SSL exception handling
- Methods: `getNowPlayingTvSeries`, `getPopularTvSeries`, `getTopRatedTvSeries`, `getTvSeriesDetail`, `getTvSeriesRecommendations`, `searchTvSeries`

**Error Handling Pattern:**
```dart
try {
  final result = await remoteDataSource.getXXX();
  return Right(result.map((model) => model.toEntity()).toList());
} on ServerException {
  return Left(ServerFailure(''));
} on SocketException {
  return Left(ConnectionFailure('Failed to connect to the network'));
} on TlsException catch (e) {
  return Left(SSLFailure('Certificate verification failed: ${e.message}'));
}
```

### 6. Main App Initialization
**File**: `lib/main.dart`

Aplikasi menunggu sampai HTTP client dengan SSL pinning siap sebelum running:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  di.init();
  await di.locator.allReady(); // Menunggu async dependencies
  runApp(MyApp());
}
```

### 7. Assets Configuration
**File**: `pubspec.yaml`

Sertifikat ditambahkan ke assets:
```yaml
flutter:
  assets:
    - assets/
    - certificates/
```

## Cara Kerja SSL Pinning

1. **Inisialisasi**
   - Saat aplikasi start, HTTP client dengan SSL pinning diinisialisasi
   - Sertifikat `tmdb.pem` dimuat dari assets

2. **Request Validation**
   - Setiap request ke TMDB API menggunakan HTTP client yang telah dikonfigurasi
   - SecurityContext memverifikasi sertifikat server dengan sertifikat yang di-pin
   - Jika sertifikat tidak cocok, koneksi ditolak

3. **Error Handling**
   - `TlsException`: Sertifikat tidak valid atau tidak cocok
   - `SocketException`: Masalah koneksi jaringan
   - `ServerException`: Error dari API server

## Keuntungan Implementasi

1. **Security**: Mencegah Man-in-the-Middle (MITM) attacks
2. **Trust**: Hanya berkomunikasi dengan server yang terverifikasi
3. **Data Protection**: Melindungi data pengguna dari intersepsi
4. **Compliance**: Memenuhi standar keamanan aplikasi modern

## Testing

Untuk menguji SSL Pinning:

```bash
# 1. Run flutter analyze
flutter analyze

# 2. Build aplikasi
flutter build apk

# 3. Test koneksi ke TMDB API
# Aplikasi harus berhasil load data dari API
```

## Maintenance

**Update Sertifikat:**
1. Download sertifikat terbaru dari api.themoviedb.org
2. Replace file `certificates/tmdb.pem`
3. Test aplikasi untuk memastikan koneksi berhasil

**Monitoring:**
- Check expiry date sertifikat secara berkala
- Update sertifikat sebelum expired
- Test aplikasi setelah update sertifikat

## Troubleshooting

**Masalah**: `TlsException: Certificate verification failed`
**Solusi**: 
- Periksa apakah sertifikat masih valid
- Update sertifikat jika sudah expired
- Pastikan file tmdb.pem ada di folder certificates

**Masalah**: Aplikasi tidak bisa load data
**Solusi**:
- Periksa koneksi internet
- Cek apakah API TMDB sedang down
- Verifikasi API key masih valid

## Security Notes

⚠️ **Important:**
- JANGAN commit API key ke public repository
- Simpan sertifikat di lokasi yang aman
- Update sertifikat secara berkala
- Monitor log untuk SSL errors

## Dependencies

```yaml
dependencies:
  http: ^1.2.2
  flutter/services.dart # Untuk load assets
```

## References

- [TMDB API Documentation](https://developers.themoviedb.org/)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)
- [SSL Pinning Guide](https://owasp.org/www-community/controls/Certificate_and_Public_Key_Pinning)
