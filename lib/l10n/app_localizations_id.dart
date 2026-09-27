// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Referensi Obat';

  @override
  String get medicationListTitle => 'Daftar Obat';

  @override
  String get emptyStateMessage => 'Obat tidak ditemukan';

  @override
  String get errorRetryButton => 'Coba Lagi';

  @override
  String get medicationNameUnavailable => 'Nama tidak tersedia';

  @override
  String get manufacturerUnavailable => 'Produsen tidak diketahui';

  @override
  String get bottomNavMedications => 'Obat';

  @override
  String get bottomNavFavorites => 'Favorit';

  @override
  String get favoritesScreenTitle => 'Favorit';

  @override
  String get favoritesEmpty =>
      'Belum ada favorit. Tekan ikon bintang di halaman detail obat untuk menyimpannya di sini.';

  @override
  String get favoritesRemoved => 'Dihapus dari favorit';

  @override
  String get favoritesRemoveFailed =>
      'Gagal menghapus dari favorit. Silakan coba lagi.';

  @override
  String get searchHint => 'Cari nama obat, merek, atau bahan aktif';

  @override
  String get searchClear => 'Hapus pencarian';

  @override
  String get errorNetwork =>
      'Tidak ada koneksi internet. Periksa koneksi lalu coba lagi.';

  @override
  String get errorServer =>
      'Server sedang bermasalah. Silakan coba lagi nanti.';

  @override
  String get errorRateLimit =>
      'Terlalu banyak permintaan. Tunggu sebentar lalu coba lagi.';

  @override
  String get errorInvalidData => 'Data yang diterima tidak dapat dibaca.';

  @override
  String get errorUnknown => 'Terjadi kesalahan. Silakan coba lagi.';

  @override
  String get detailBack => 'Kembali';

  @override
  String get detailAddFavorite => 'Tambah ke favorit';

  @override
  String get detailRemoveFavorite => 'Hapus dari favorit';

  @override
  String get badgeOtc => 'OTC';

  @override
  String get badgePrescription => 'Resep';

  @override
  String get sectionPurpose => 'Kegunaan';

  @override
  String get sectionDosage => 'Dosis & Cara Pakai';

  @override
  String get sectionActiveIngredients => 'Bahan Aktif';

  @override
  String get sectionWarnings => 'Peringatan';

  @override
  String get sectionInactiveIngredients => 'Bahan Tidak Aktif';

  @override
  String get medicalDisclaimer =>
      'Informasi ini untuk keperluan referensi teknis, bukan pengganti saran medis profesional.';
}
