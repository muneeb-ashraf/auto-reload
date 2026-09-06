## What's fixed

- **"Active Tab" now reloads only the tab you started it on.** Previously the extension looked up whichever tab was in front each time the timer fired, so switching tabs in the same window caused every tab you visited to be reloaded. The tab is now captured when you press Start and stays pinned until you press Stop.
- "All Tabs" behaviour is unchanged.

## Installing the `.app.zip`

This build is ad-hoc signed (no Apple Developer certificate) and not notarized, so macOS and Safari need a one-time opt-in:

1. Download and unzip the `.app.zip`, then move **Auto Reload.app** to `/Applications`.
2. Because the app is not notarized, the first launch is blocked by Gatekeeper. Either:
   - Open **System Settings → Privacy & Security**, scroll down and click **Open Anyway** next to the Auto Reload message, or
   - run `xattr -cr "/Applications/Auto Reload.app"` in Terminal, then open the app normally.
3. Open **Auto Reload.app** once so macOS registers the extension.
4. In Safari, enable the Develop menu (**Safari → Settings → Advanced → Show features for web developers**), then choose **Develop → Allow Unsigned Extensions** (Safari 17+: **Settings → Developer → Allow unsigned extensions**). Safari resets this each time it is relaunched.
5. Go to **Safari → Settings → Extensions** and turn on **Auto Reload**.

If you have an Apple Developer account, opening the Xcode project and building with your own team will produce a signed build that does not need step 4.
