# Flutter Kurulum ve Kurulum Kılavuzu (Windows)

Bilgisayarınızda `flutter` komutunun çalışması için Flutter SDK'sının kurulu olması ve "PATH"e eklenmiş olması gerekmektedir.

## 1. Flutter SDK İndirme
1. [Resmi Flutter Sitesinden](https://docs.flutter.dev/get-started/install/windows) **Flutter Windows SDK** zip dosyasını indirin.
2. Zip dosyasını `C:\src\flutter` gibi basit bir dizine çıkartın. (Örneğin: `Program Files` içine **atmayın**, izin sorunu çıkabilir).

## 2. PATH Ayarı (En Önemli Adım)
Terminalin `flutter` komutunu tanıması için:
1. **Başlat** menüsüne "ortam değişkenleri" yazın ve **"Sistem ortam değişkenlerini düzenleyin"** seçeneğine tıklayın.
2. Açılan pencerede **"Ortam Değişkenleri..."** butonuna basın.
3. **"Kullanıcı değişkenleri"** bölümünde **"Path"**i bulun ve **"Düzenle"**ye tıklayın.
4. **"Yeni"** butonuna basın ve Flutter'ın `bin` klasörünün tam yolunu yapıştırın.
   - Örnek: `C:\src\flutter\bin`
5. Tüm pencerelere "Tamam" diyerek çıkın.

## 3. Doğrulama
1. Mevcut tüm terminalleri (CMD, PowerShell, VS Code) kapatıp yeniden açın.
2. Şu komutu çalıştırın:
   ```powershell
   flutter --version
   ```
3. Eğer sürüm numarası görürseniz işlem tamamdır!

## 4. Projeyi Çalıştırma
Kurulum tamamlandıktan sonra proje dizininde:
```powershell
flutter pub get
flutter run
```
komutlarını çalıştırarak uygulamayı açabilirsiniz.
