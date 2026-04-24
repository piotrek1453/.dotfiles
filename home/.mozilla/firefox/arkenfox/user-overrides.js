/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
// user_pref("browser.privatebrowsing.autostart", false); // 0110 required if you had it set as true
// user_pref("browser.sessionstore.privacy_level", 0); // 1003 optional to restore cookies/formdata
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false); // 2811 FF128-135
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false); // 2812 FF136+

// optional to match when you use settings>Cookies and Site Data>Clear Data
// user_pref("privacy.clearSiteData.historyFormDataAndDownloads", false); // 2820 FF128-135
// user_pref("privacy.clearSiteData.browsingHistoryAndDownloads", false); // 2821 FF136+

// optional to match when you use Ctrl-Shift-Del (settings>History>Custom Settings>Clear History)
// user_pref("privacy.clearHistory.historyFormDataAndDownloads", false); // 2830 FF128-135
// user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false); // 2831 FF136+

// don't close browser with last tab closed
user_pref("browser.tabs.closeWindowWithLastTab", false);

//disable AI stuff
user_pref("browser.assistant.enabled", false);
user_pref(
  "browser.newtabpage.activity-stream.asrouter.providers.messagingassistant",
  "",
);
user_pref(
  "browser.newtabpage.activity-stream.asrouter.providers.messagingassistant-activity-stream",
  "",
);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("extensions.activeAddons", "{}");
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.chat.page.menuBadge", false);
user_pref("browser.ml.chat.page.footerBadge", false);
user_pref("browser.ml.chat.menu", false);
user_pref("browser.ml.chat.shortcuts", false);
user_pref("browser.ml.chat.sidebar", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("extensions.ml.enabled", false);
user_pref("sidebar.revamp", false);
user_pref("sidebar.revamp.defaultLauncherVisible", false);
user_pref("sidebar.notification.badge.aichat", false);

// enable tab grouping
user_pref("browser.tabs.groups.enabled", true);

// accept only necessary cookies
user_pref("network.cookie.cookieBehavior", 1);
user_pref("network.cookie.lifetimePolicy", 0);

// disable speech dispatcher
user_pref("media.webspeech.synth.enabled", false);

// use OS theme
user_pref("ui.systemUsesDarkTheme", 2);
// prefer dark mode everywhere
user_pref("layout.css.prefers-color-scheme.content-override", "dark");
