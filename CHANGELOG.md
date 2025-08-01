## 4.0.0

- **Breaking**: Removed `SurveyWidget` and `BiLabsLeaderboard`.
- Make the SDK a native plugin with iOS and Android support.
- [iOS] Add SPM support for iOS.
- [Android] **Breaking** Minimum versions: 
  - AGP: **8.1.0**.
  - Gradle: **8.7**.
  - Kotlin: **2.1.0**.

## 3.0.1

- Expose Survey and Category models
- Internal Improvements

## 3.0.0

- Bump dependencies versions to latest
- Bump minimum Flutter/Dart version to 3.24.0/3.5.0

## 2.2.16

- Improve Survey and app bar opening mechanism 

## 2.2.15

- Add native back functionality to the Offerwall. Now you can go back to the previous page in the
  Offerwall using the back button on the device.

## 2.2.14

- Add crash reporting for better debugging: we had a compilation issue with this feature, so we had
  to remove it in the previous version. We have fixed the issue and added it back in this version.

## 2.2.13

- Remove crash reporting due to compilation issues

## 2.2.12

- Add crash reporting for better debugging

## 2.2.11

- **Bugfix:** Offer/Game opens both internally and externally.
- **Bugfix:** Offer Support Page related bugs.

## 2.2.10

- **Bugfix:** Continue Playing button opens the game as a survey instead of opening the play
  store/app store.

## 2.2.9

- **Bugfix:** HookMessage parse error

## 2.2.8

- **Add User-Agent to the requests**

## 2.2.7

- **Expose Restriction Reason as an Exception for getSurveys()**

## 2.2.6

- **Use PostMessage API for communication with the Offerwall**

## 2.2.5

- **Improvements**

## 2.2.4

- **Bugfix**: Fix the issue when Modal Bottom Sheet is clipped or not showing

## 2.2.3

- **Bugfix**: QR Code appears without errors

## 2.2.2

- **Offer Support Page**: Now you can report to use in case there is a problem with an Offer.
  The **Report a Problem** option is now available in the Offer overview page once you start the
  offer.

## 2.2.1

- **Magic Receipts**: Add Magic Receipts to the Offerwall. You can now reward users for scanning
  receipts. Make sure to enable that in your Dashboard.

## 2.2.0

- **Widget Migration**:Migrate Widgets to new WebView Components for scalability.
  Deprecated `BitLabsLeaderboard` and `getSurveyWidgets()`. Use ``BitLabsWidget`instead.

## 2.1.13

- **Bugfix**: QR Code appears unnecessarily. Add a toggle flag to whether to display the QR Code.

## 2.1.12

- **Add Tests**

## 2.1.11

- **Important Bug Fixes**

## 2.1.10

- **Bugfix**: Fix Closse Offerwall button not showing when going back to Offerwall from Survey.

## 2.1.9

- **Add os parameter to offerwall.**

## 2.1.8

- **Remove Open Offerwall externally.**

## 2.1.7

- **Bugfix**: Ignore irrelevant errors in the Webview.

## 2.1.6

- **Bugfix**: Remove Error QR Code when the Webview is reset.

## 2.1.5

- **New Exit Button**: Changed the exit button for better UX.

## 2.1.4

- **Error QR Code**: Show a QR Code when there is an http error in the web widget.
- **Improvements**

## 2.1.3

- **Promotion View**: Show a promotion in the survey widgets to your users when available in you
  Dashboard.
- **Bugfix**: Leaderboard not showing when there is user data.
- **Code Optimisation and improvements**

## 2.1.2

- **Migrate to API v2**

## 2.1.1

- **Bugfix**: Offers aren't opening.

## 2.1.0

- **Add Simple and Full Width widgets**
- **Add Leaderboard widget**
- **Support Gradient Colors**
- **Bugfixes and improvements**

## 2.0.1

- **UI Improvements**

## 2.0.0

- **Add Native Survey Widgets**: You can add a List of Native Survey Widgets.
- **New Error Handling Implementation**
- **Code Optimisation and improvements**

## 1.1.0

- **Support Offers**: Now you can use offers inside the Offerwall.

## 1.0.0

Official first release of BitLabs on Flutter
