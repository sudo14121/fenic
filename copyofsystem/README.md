# Backup SD-карты Raspberry Pi 5 (Pupper-v3 / Fenek)

Снимок сделан **2026-09-12** с карты в ридере (Disk 2, boot = `F:`).

## Содержимое

| Путь | Что это |
|------|---------|
| `bootfs/` | Полная копия boot-раздела (FAT32, ~512 МБ) |
| `original/` | Оригинальные `config.txt` и `cmdline.txt` до правок |
| `rootfs.img` | Raw-образ ext4 root (~59 ГБ) — создаётся скриптом |
| `dump-rootfs.ps1` | Скрипт дампа root-раздела |
| `partition-info.json` | Смещения разделов для восстановления |

## Boot-профили

**v3 — быстрый boot без ожиданий (текущий):**

- `camera_auto_detect=1` + `display_auto_detect=1` — камера/DSI подхватятся сами, **без таймаутов** если отключены
- Убраны принудительные overlays (ov5647, waveshare, hifiberry) из основного config
- `cmdline.txt` — **без `splash`/`quiet`/plymouth** (быстрее визуальный старт)
- Опционально при сборке робота:
  - `include hardware.dsi.txt` — Waveshare cam/disp (если auto-detect не видит)
  - `include hardware.hats.txt` — HiFiBerry

**Когда вставишь SD в Pi с HDMI**, можно править прямо на Pi:
```bash
sudo nano /boot/firmware/config.txt
sudo nano /boot/firmware/cmdline.txt
sudo reboot
```

## Восстановить boot на SD

```powershell
robocopy D:\dog\fox\copyofsystem\bootfs F:\ /MIR
```

## Дамп root-раздела (если ещё не готов)

PowerShell **от администратора**, SD в ридере, ~1–2 часа через USB:

```powershell
cd D:\dog\fox\copyofsystem
powershell -ExecutionPolicy Bypass -File .\dump-rootfs.ps1
```

Прогресс: `dump-rootfs.log`

## Откат boot-конфига

```powershell
Copy-Item D:\dog\fox\copyofsystem\original\config.txt F:\config.txt -Force
```

## Диагностика карты

- Запись ~**11 МБ/с** — медленно для Pi 5, карта изнашивается
- Boot FAT: **Full Repair Needed** — рекомендуется `chkdsk F: /F` от администратора
