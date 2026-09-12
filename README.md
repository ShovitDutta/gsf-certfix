# GSF CertFix

One-tap GSF Android ID for Play Protect certification + optional Play Store reset.
Magisk / KernelSU (incl. ReSukiSU) / APatch module.

## Use

1. Flash the zip in your root manager (manager-app install only, not recovery).
2. Open the module, tap **ACTION** anytime:
   - Shows your GSF Android ID → register it at
     `https://www.google.com/android/uncertified`
   - **Vol+** = clear Play Store (you reboot)
   - **Vol-** = clear Play Store + reboot now

## OTA

`updateJson` in `module.prop` points at `update.json` on `main`.
Managers check it automatically, like ZygiskNext.
