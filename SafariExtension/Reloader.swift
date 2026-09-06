//
//  Reloader.swift
//  AutoReload
//
//  Created by Garrett Johnson on 9/23/18.
//  Copyright © 2018 Garrett Johnson.
//
//  SPDX-License-Identifier: MIT
//

import Foundation
import SafariServices

class Reloader {
    private var timer: Timer?

    var window: SFSafariWindow
    /// The tab that was active when the reloader was started.
    /// Only used when `allTabs` is false so that reloads stay pinned to this
    /// tab even if the user switches to another tab in the same window.
    var tab: SFSafariTab?
    var allTabs: Bool
    var interval: Double

    init(window: SFSafariWindow, tab: SFSafariTab?, allTabs: Bool, interval: Double) {
        self.window = window
        self.tab = tab
        self.allTabs = allTabs
        self.interval = interval
        self.startTimer()
    }

    @objc func reload() {
        if allTabs {
            window.getAllTabs { tabs in
                for tab in tabs {
                    tab.getActivePage { page in
                        page?.reload()
                    }
                }
            }
        } else if let tab = tab {
            // Reload only the tab that was active when the timer was started,
            // regardless of which tab is currently in front.
            tab.getActivePage { page in
                page?.reload()
            }
        } else {
            // No tab was captured when starting (should not normally happen);
            // fall back to whatever tab is currently active.
            window.getActiveTab { tab in
                tab?.getActivePage { page in
                    page?.reload()
                }
            }
        }
    }

    func startTimer() {
        NSLog("Adding a new timer with \(interval) second interval...")
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {_ in
            self.reload()
        }
    }

    func stopTimer() {
        NSLog("Stopping timer...")
        timer?.invalidate()
    }

    func getSecondsUntilReload() -> Double {
        if let timer = timer {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.second], from: Date(), to: timer.fireDate)

            if let seconds = components.second {
                return Double(seconds) + 1.0
            } else {
                return 0
            }
        }

        return -1
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension Reloader: Hashable {
    static func == (lhs: Reloader, rhs: Reloader) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(window)
    }
}
