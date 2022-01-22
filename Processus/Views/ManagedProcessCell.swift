import SwiftUI

struct ManagedProcessCell: View {
    let viewModel: ManagedProcessCellViewModel
    
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(viewModel.isRunning ? .green : .red)
                .frame(width: 15.0, height: 15.0)
                .onTapGesture(perform: viewModel.toggle)
            VStack(alignment: .leading) {
                Text(viewModel.formattedName)
                    .font(.system(size: 12.0, weight: .bold))
                Text(viewModel.formattedCommand)
                    .font(.system(size: 12.0))
                    .foregroundColor(.gray)
            }
            Spacer()
            MenuButton(label: Image(systemName: "gear")) {
                Button(action: viewModel.toggle) {
                    Text(viewModel.formattedToggleButtonText)
                }
                Button(action: viewModel.edit) {
                    Text("Edit")
                }
                Button(action: viewModel.remove) {
                    Text("Remove")
                }
            }
            .frame(maxWidth: 50)
            .scaledToFit()
        }
    }
}
