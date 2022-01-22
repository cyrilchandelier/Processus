import Foundation

final class ManagedProcessCellViewModel: ObservableObject {
    // MARK: - Public API
    
    // MARK: Initiliazers
    init(
        process: ManagedProcess,
        onToggle: @escaping (ManagedProcess) -> Void,
        onEdit: @escaping (ManagedProcess) -> Void,
        onDelete: @escaping (ManagedProcess) -> Void
    ) {
        self.process = process
        self.onToggle = onToggle
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    // MARK: Observables
    @Published private(set) var process: ManagedProcess

    // MARK: Interface configuration
    var isRunning: Bool {
        return process.isRunning
    }

    var formattedToggleButtonText: String {
        return process.isRunning ? "Stop" : "Start"
    }

    var formattedName: String {
        return process.name
    }

    var formattedCommand: String {
        return process.command
    }

    func toggle() {
        onToggle(process)
    }
    
    func edit() {
        onEdit(process)
    }
    
    func remove() {
        onDelete(process)
    }
    
    // MARK: - Private
    
    // MARK: Callbacks
    private let onToggle: (ManagedProcess) -> Void
    private let onEdit: (ManagedProcess) -> Void
    private let onDelete: (ManagedProcess) -> Void
}
