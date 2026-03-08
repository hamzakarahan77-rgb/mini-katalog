# 🛍️ Mini Katalog Uygulaması

Flutter ile geliştirilmiş, Fake Store API kullanan profesyonel bir mobil katalog uygulaması.

## 📱 Ekran Görüntüleri

| Ana Sayfa | Ürün Detayı | Sepet |
|-----------|-------------|-------|
| GridView ürün listesi | Tam açıklama + puan | Miktar kontrolü |

## ✨ Özellikler

- 🔍 **Anlık Arama** – Ürün adına göre filtreleme
- 🏷️ **Kategori Filtresi** – API'den gelen kategoriler
- 🛒 **Sepet Sistemi** – Ekleme, çıkarma, miktar güncelleme
- 📦 **Ürün Detayı** – Görsel, açıklama, yıldız puanı
- 🌐 **Gerçek API** – Fake Store API entegrasyonu
- ⚡ **Cached Images** – cached_network_image paketi

## 🛠️ Kullanılan Teknolojiler

| Araç | Versiyon |
|------|----------|
| Flutter | >=3.0.0 |
| Dart | >=3.0.0 |
| http | ^1.2.0 |
| cached_network_image | ^3.3.1 |

## 📁 Proje Yapısı

```
lib/
├── main.dart                    # Uygulama giriş noktası
├── models/
│   └── product.dart             # Product & CartItem modeli (fromJson/toJson)
├── services/
│   ├── product_service.dart     # Fake Store API servisi
│   └── cart_provider.dart       # Sepet state yönetimi (ChangeNotifier)
├── screens/
│   ├── home_screen.dart         # Ana ekran (arama + filtre + GridView)
│   ├── product_detail_screen.dart # Ürün detay sayfası
│   └── cart_screen.dart         # Sepet ekranı
└── widgets/
    └── product_card.dart        # Yeniden kullanılabilir ürün kartı
```

## 🚀 Çalıştırma Adımları

```bash
# 1. Projeyi klonla
git clone https://github.com/kullanici-adi/mini_katalog.git
cd mini_katalog

# 2. Bağımlılıkları yükle
flutter pub get

# 3. Emülatör veya cihazı başlat
flutter devices

# 4. Uygulamayı çalıştır
flutter run
```

## 📡 API

Bu uygulama [Fake Store API](https://fakestoreapi.com/) kullanmaktadır:

- `GET /products` – Tüm ürünler
- `GET /products/categories` – Kategoriler
- `GET /products/category/{category}` – Kategoriye göre ürünler

## 🎓 Eğitim Kapsamı

- Widget ağacı ve Stateful/Stateless widget
- Navigator.push / pop ile sayfa geçişleri
- Route Arguments ile veri taşıma
- ListView.builder ve GridView.builder
- JSON veri modelleme (fromJson/toJson)
- ChangeNotifier ile state yönetimi
- http paketi ile REST API kullanımı
