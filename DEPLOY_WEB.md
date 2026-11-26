# ฝาก Glow เวอร์ชันเว็บบน GitHub Pages

> build เว็บผ่านและลองบนเครื่องแล้ว แต่ **ยังไม่เคย deploy** ขั้นตอน GitHub Pages ด้านล่างยังไม่เคยรันจริง

## ก่อน deploy ครั้งแรก

- GitHub Pages แบบฟรีใช้ได้กับ repo สาธารณะ ถ้า repo เป็น private ต้องใช้แพ็กเกจที่รองรับ
- ทุกเว็บใต้ `<ชื่อผู้ใช้>.github.io` ถือเป็น **origin เดียวกัน** หน้าอื่นในบัญชีเดียวกันจึงอ่าน
  ที่เก็บข้อมูลของ Glow ได้ รวมถึง API key ใช้ key ที่จำกัดให้ใช้ได้แค่ Gemini และตั้งวงเงินไว้
  อย่าฝากหน้าเว็บที่ไม่ไว้ใจในบัญชีเดียวกัน

## build

```powershell
dart run tool/build_web.dart
```

- ค่าเริ่มต้น `--base-href` คือ `/Glow-App/` (ต้องตรงกับชื่อ repo ตัวพิมพ์เล็กใหญ่ด้วย)
- ถ้าใช้โดเมนของตัวเองที่ root: `dart run tool/build_web.dart --base-href /`
- ถ้ารันใน Git Bash และส่ง `--base-href` เอง ให้ใส่ `MSYS_NO_PATHCONV=1` นำหน้า
- ห้ามใช้ `flutter build web` ตรง ๆ สำหรับตัวที่จะ deploy เพราะรายการไฟล์ออฟไลน์จะว่าง

## ลองบนเครื่องก่อน deploy

```powershell
flutter run -d chrome
```

## deploy ครั้งแรก

ใช้ branch `gh-pages` แยก ไม่ปนกับโค้ด รันจากโฟลเดอร์โปรเจกต์:

```powershell
git worktree add --orphan -b gh-pages ../glow-pages
Copy-Item -Recurse -Force build/web/* ../glow-pages/
Copy-Item -Force build/web/.nojekyll ../glow-pages/
cd ../glow-pages
git add -A
git commit -m "Deploy web version"
git push -u origin gh-pages
```

จากนั้นใน GitHub: **Settings → Pages → Deploy from a branch → `gh-pages` / `(root)`**
เว็บจะอยู่ที่ `https://<ชื่อผู้ใช้>.github.io/Glow-App/`

## อัปเดตเวอร์ชัน

```powershell
dart run tool/build_web.dart
cd ../glow-pages
git rm -r -q .
Copy-Item -Recurse -Force ../Glow-App/build/web/* .
Copy-Item -Force ../Glow-App/build/web/.nojekyll .
git add -A
git commit -m "Update web version"
git push
```

`git rm -r` ลบไฟล์เก่าใน `glow-pages` ก่อน เช็กว่าอยู่ในโฟลเดอร์ `glow-pages` จริงก่อนรัน

## ให้เครื่องผู้ใช้โหลดเวอร์ชันใหม่

- ทุก build ที่เนื้อหาเปลี่ยนจะได้ `VERSION` ใหม่ใน `sw.js` เมื่อเปิดแอป (หรือกลับเข้าแอป)
  จะขึ้นแถบ "มีเวอร์ชันใหม่ กดเพื่อโหลดใหม่"
- GitHub Pages แคชไฟล์ไว้ราว 10 นาที ถ้าแถบยังไม่ขึ้น รอแล้วเปิดใหม่
- ถ้าค้างจริง: Safari บนคอมพิวเตอร์หรือ Chrome DevTools → Application → Service Workers →
  Unregister
- **บน iPhone อย่าแนะนำให้ล้างข้อมูลเว็บไซต์** เพราะฐานข้อมูลของ Glow จะหายด้วย ให้สำรองข้อมูลก่อนเสมอ

## ไฟล์ฐานข้อมูลใน `web/`

| ไฟล์ | มาจาก |
| --- | --- |
| `sqlite3.wasm` | release `sqlite3-3.9.2` ของ `simolus3/sqlite3.dart` |
| `drift_worker.js` | release `drift-2.35.4` ของ `simolus3/drift` |

ถ้าอัปเกรด `drift` หรือ `sqlite3` ใน `pubspec.lock` ต้องดาวน์โหลดสองไฟล์นี้ให้ตรงเวอร์ชันใหม่

## เรื่องที่ควรรู้

- ฟอนต์ไทยและตัวเลขอยู่ในแอป แต่ถ้ามีอักขระที่ฟอนต์ไม่มี Flutter web อาจโหลดฟอนต์สำรองจาก
  `fonts.gstatic.com` ตรวจในแท็บ Network ตอนลองบน Chrome
