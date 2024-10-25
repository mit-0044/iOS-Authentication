//
//  AppearanceSetting.swift
//  Authentication
//
//  Created by Mit Patel on 09/10/24.
//

import SwiftUI

struct AppearanceSettingsView: View {
    @EnvironmentObject var appearanceSetting: AppearanceSettings

    var body: some View {
        List {
            Picker("Appearance", selection: $appearanceSetting.appearanceType) {
                ForEach(AppearanceSettings.AppearanceType.allCases, id: \.self) { appearance in
                    Text(appearance.rawValue.capitalized)
                        .tag(appearance)
                }
            }
            .pickerStyle(.inline)
        }
        .navigationTitle("Appearance Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppearanceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSettingsView()
            .environmentObject(AppearanceSettings())
    }
}
