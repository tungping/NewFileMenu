import SwiftUI

struct FolderListView: View {
    @Binding var folders: [URL]
    @Binding var selection: Set<URL>

    let onAdd: () -> Void
    let onRemove: () -> Void
    let onRestoreDefaults: () -> Void
    let strings: AppStrings

    var body: some View {
        GroupBox(strings.monitoredFoldersTitle) {
            VStack(spacing: 8) {
                List(selection: $selection) {
                    ForEach(folders, id: \.self) { folder in
                        Label(folder.path, systemImage: "folder")
                            .lineLimit(1)
                            .tag(folder)
                    }
                }
                .frame(minHeight: 95)

                HStack {
                    Button(action: onAdd) {
                        Label(strings.add, systemImage: "plus")
                    }

                    Button(action: onRemove) {
                        Label(strings.remove, systemImage: "minus")
                    }
                    .disabled(selection.isEmpty)

                    Spacer()

                    Button(action: onRestoreDefaults) {
                        Label(strings.restoreDefaultFolders, systemImage: "arrow.counterclockwise")
                    }
                }
            }
        }
    }
}
