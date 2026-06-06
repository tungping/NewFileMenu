import SwiftUI

struct ExtensionHelpView: View {
    let strings: AppStrings

    var body: some View {
        GroupBox(strings.helpTitle) {
            VStack(alignment: .leading, spacing: 6) {
                Text(strings.helpEnableExtension)
                Text(strings.helpRestartFinder)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
