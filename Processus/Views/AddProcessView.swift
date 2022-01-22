import Introspect
import SwiftUI

struct AddProcessView: View {
    @ObservedObject var viewModel: AddProcessViewModel
    
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
                Button(action: createButtonTapped) {
                    Text("Create")
                }
                .disabled(!viewModel.canCreate)
            }
        }
        .padding()
    }
    
    private func cancelButtonTapped() {
        viewModel.cancel()
    }
    
    private func createButtonTapped() {
        viewModel.create()
    }
}
