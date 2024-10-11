# Smart City app

## Link Flow app
[Link](https://drive.google.com/file/d/10f0Kf6xwWv7Tm-ht-PghVyFAthieLKF8/view?usp=drive_link)

## Cấu trúc project
- Router của app sẽ nằm trong folder base/routes/routes
- Const value sẽ chứa colors, decorations(input và box decoration), fonts và size
- Controller sẽ chứa việc xử lý logic của app cùng bloc
- Generated và l10n sẽ chứa file chuyển tiếng
- Model sẽ chứa user model
- View sẽ chứa các màn hình giao diện của app



## 3. How to run and build
flutter pub run intl_utils:generate
This project run with flavor (prod, stg, dev)
- Run
    - Android
        - ErpMobile
            - flutter run -t lib/main.dart --flavor SmartCity
- Build
    - Create app icon
        - flutter pub run flutter_launcher_icons
    - Android
        - ErpMobile
            - flutter build apk -t lib/main.dart --release --flavor SmartCity --no-tree-shake-icons
            - flutter build appbundle -t lib/main.dart --release --flavor SmartCity  --no-tree-shake-icons
    - IOS
        - ErpMobile
            - flutter build ios -t lib/main.dart --flavor SmartCity --no-tree-shake-icons
            - flutter -v -d 2CBE3629-E627-4E02-9687-D0BB0FC47002 run