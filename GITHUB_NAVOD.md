# Android APK přes GitHub Actions

1. Nahraj soubory projektu do **kořene** repozitáře, včetně skryté složky `.github/workflows`. ZIP jako jediný soubor nestačí.
2. Otevři Actions > Build Android APK > Run workflow.
3. Po úspěšném běhu otevři jeho stránku a v sekci Artifacts stáhni `Generic-RPG-3D-Android-APK`.
4. Rozbal stažený artifact ZIP a nainstaluj `.apk`. Android může vyžadovat povolení instalace z tohoto zdroje.

Workflow je připravený, ale v tomto prostředí nebyl spuštěn ani ověřen. Pokud export selže, pošli log chyby.
