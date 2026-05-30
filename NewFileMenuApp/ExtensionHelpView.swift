import SwiftUI

struct ExtensionHelpView: View {
    let strings: AppStrings

    var body: some View {
        GroupBox(strings.helpTitle) {
            VStack(alignment: .leading, spacing: 8) {
                Text(strings.helpEnableExtension)
                Text(strings.helpRestartFinder)
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
