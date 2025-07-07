#!/usr/bin/env python3
"""
YurttaYe AdMob Doğrulama Scripti
Bu script, app-ads.txt dosyasının doğru şekilde yayınlandığını kontrol eder.
"""

import requests
import sys
from urllib.parse import urljoin

def check_app_ads_txt(domain):
    """app-ads.txt dosyasını kontrol eder"""
    url = urljoin(f"https://{domain}/", "app-ads.txt")
    
    try:
        print(f"🔍 {url} adresini kontrol ediliyor...")
        response = requests.get(url, timeout=10)
        
        if response.status_code == 200:
            content = response.text.strip()
            print(f"✅ app-ads.txt dosyası bulundu!")
            print(f"📄 İçerik: {content}")
            
            # İçeriği doğrula
            expected_content = "google.com, pub-9589008379442992, DIRECT, f08c47fec0942fa0"
            if content == expected_content:
                print("✅ İçerik doğru!")
                return True
            else:
                print("❌ İçerik yanlış!")
                print(f"Beklenen: {expected_content}")
                return False
        else:
            print(f"❌ app-ads.txt dosyası bulunamadı (HTTP {response.status_code})")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ Bağlantı hatası: {e}")
        return False

def check_website_accessibility(domain):
    """Web sitesinin erişilebilirliğini kontrol eder"""
    try:
        print(f"🔍 {domain} web sitesi kontrol ediliyor...")
        response = requests.get(f"https://{domain}/", timeout=10)
        
        if response.status_code == 200:
            print("✅ Web sitesi erişilebilir!")
            return True
        else:
            print(f"❌ Web sitesi erişilemiyor (HTTP {response.status_code})")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ Web sitesi bağlantı hatası: {e}")
        return False

def main():
    domain = "yurttaye.onrender.com"
    
    print("🚀 YurttaYe AdMob Doğrulama Kontrolü")
    print("=" * 50)
    
    # Web sitesi erişilebilirliğini kontrol et
    if not check_website_accessibility(domain):
        print("\n❌ Web sitesi erişilemiyor. Lütfen web sitesini kontrol edin.")
        sys.exit(1)
    
    print()
    
    # app-ads.txt dosyasını kontrol et
    if not check_app_ads_txt(domain):
        print("\n❌ app-ads.txt doğrulaması başarısız!")
        print("\n🔧 Çözüm önerileri:")
        print("1. app-ads.txt dosyasının web sitesinin kök dizininde olduğunu kontrol edin")
        print("2. Dosya içeriğinin doğru olduğunu doğrulayın")
        print("3. Web sitesinin güncellenmesini bekleyin (birkaç dakika)")
        sys.exit(1)
    
    print("\n🎉 Tüm kontroller başarılı!")
    print("\n📋 Sonraki adımlar:")
    print("1. AdMob hesabınızda uygulama doğrulamasını yeniden çalıştırın")
    print("2. Birkaç dakika bekleyin ve doğrulama durumunu kontrol edin")
    print("3. Sorun devam ederse AdMob desteği ile iletişime geçin")

if __name__ == "__main__":
    main() 