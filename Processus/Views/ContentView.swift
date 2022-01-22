import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ManagedProcess.id, ascending: true)], animation: .default)
    private var processes: FetchedResults<ManagedProcess>
    
    let viewModel: ContentViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(processes) { process in
                    ManagedProcessCell(
                        viewModel: ManagedProcessCellViewModel(
                            process: process,
                            onToggle: viewModel.toggleRequested,
                            onEdit: viewModel.editRequested,
                            onDelete: viewModel.deleteRequested
                        )
                    )
                }
            }
            HStack {
                Button(action: createProcessButtonTapped) {
                    Label("Add Process", systemImage: "plus")
                }
                Spacer()
                Menu {
                    Button(action: quitButtonTapped) {
                        Text("Quit Processus")
                    }
                } label: {
                     Image(systemName: "gear")
                }
                .frame(maxWidth: 50)
            }
            .padding()
        }
    }

    private func createProcessButtonTapped() {
        viewModel.createProcess()
    }
    
    private func quitButtonTapped() {
        viewModel.terminate()
    }
}
