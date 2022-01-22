import SwiftUI

struct EditProcessView: View {
    @ObservedObject var viewModel: EditProcessViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("", text: $viewModel.name)
            }
            Section(header: Text("Command")) {
                TextEditor(text: $viewModel.command)
                    .lineLimit(5)
            }
            Section(header: Text("Working directory")) {
                TextField("", text: $viewModel.workingDirectory)
            }
            Spacer().frame(height: 15)
            Toggle(isOn: $viewModel.launchAutomatically) {
                Text("Launch this process automatically when Processus starts")
            }
            HStack {
                Spacer()
                Button(action: cancelButtonTapped) {
                    Text("Cancel")
                }
                Button(action: saveButtonTapped) {
                    Text("Save")
                }
                .disabled(!viewModel.canSave)
            }
        }
        .padding()
    }
    
    private func cancelButtonTapped() {
        viewModel.cancel()
    }
    
    private func saveButtonTapped() {
        viewModel.save()
    }
}
