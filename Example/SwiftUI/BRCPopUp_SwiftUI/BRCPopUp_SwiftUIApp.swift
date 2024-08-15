//
//  BRCPopUp_SwiftUIApp.swift
//  BRCPopUp_SwiftUI
//
//  Created by sunzhixiong on 2024/8/12.
//

import SwiftUI
import BRCFastTest
import FLEX

@main
struct BRCPopUp_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            BRCMainContentView<MainView> {
                MainView()
            } onClickDebugButton: {
                FLEXManager.shared.toggleExplorer()
            }
        }
    }
}
