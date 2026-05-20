# K-Viet Talk Android brand asset checklist

This project does not include final app icon or splash artwork yet.

## App icon

Current Android launcher icon entry:

- `android/app/src/main/AndroidManifest.xml`
- `android:icon="@mipmap/ic_launcher"`

Files to replace when the final icon is ready:

- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

Recommended source artwork before export:

- PNG, 1024 x 1024 px or larger
- Square canvas
- Simple mark that stays readable at small sizes
- Avoid tiny text inside the icon
- Keep a safe margin around the main symbol

## Splash screen

Current Android splash entry:

- `android/app/src/main/res/values/styles.xml`
- `android/app/src/main/res/values-night/styles.xml`
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/drawable-v21/launch_background.xml`

Current behavior:

- Android shows `LaunchTheme`
- `LaunchTheme` uses `@drawable/launch_background`
- `launch_background.xml` currently shows only a plain background

Manual no-package option when artwork is ready:

1. Add splash image resources, for example `launch_image.png`, to density folders or drawable folders.
2. Uncomment/add a centered bitmap item in both `launch_background.xml` files.
3. Keep background color simple and close to the app theme.
4. Test on a real Android device before release.

Package-assisted option:

- `flutter_launcher_icons` can generate icon densities from one source image.
- `flutter_native_splash` can generate Android splash resources consistently.

Do not add these packages until the final source artwork exists.
