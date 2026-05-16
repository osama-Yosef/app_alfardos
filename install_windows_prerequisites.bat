@echo off
:: ============================================================
:: Al-Firdous App — Windows Prerequisites Installer
:: شغّل هذا الملف كـ Administrator قبل تثبيت التطبيق
:: ============================================================

echo.
echo ========================================
echo   Al-Firdous - تثبيت المتطلبات
echo ========================================
echo.

:: ── 1. Visual C++ Redistributable ─────────────────────────
echo [1/2] جاري تنزيل Visual C++ Redistributable...
curl -L -o "%TEMP%\vc_redist.x64.exe" "https://aka.ms/vs/17/release/vc_redist.x64.exe"

if %ERRORLEVEL% == 0 (
    echo تم التنزيل بنجاح. جاري التثبيت...
    "%TEMP%\vc_redist.x64.exe" /quiet /norestart
    echo [✓] Visual C++ Redistributable تم تثبيته
) else (
    echo [!] فشل التنزيل — تحقق من الاتصال بالإنترنت
)

echo.

:: ── 2. WebView2 Runtime ────────────────────────────────────
echo [2/2] جاري تنزيل Microsoft WebView2 Runtime...
curl -L -o "%TEMP%\MicrosoftEdgeWebview2Setup.exe" "https://go.microsoft.com/fwlink/p/?LinkId=2124703"

if %ERRORLEVEL% == 0 (
    echo تم التنزيل بنجاح. جاري التثبيت...
    "%TEMP%\MicrosoftEdgeWebview2Setup.exe" /silent /install
    echo [✓] WebView2 Runtime تم تثبيته
) else (
    echo [!] فشل التنزيل — قد يكون مثبتاً مسبقاً
)

echo.
echo ========================================
echo   اكتمل التثبيت! يمكنك الآن تشغيل
echo   Al-Firdous بدون مشاكل.
echo ========================================
echo.
pause
