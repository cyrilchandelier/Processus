import Foundation
import CoreData
import SwiftUI

final class EditProcessViewModel: ObservableObject {
    // MARK: - Public API
    
    // MARK: Initializers
    init(process: ManagedProcess, context: NSManagedObjectContext) {
        self.process = process
        self.context = context
        
        name = process.name
        command = process.command
        workingDirectory = process.workingDirectory
        launchAutomatically = process.launchAutomatically
    }
    
    // MARK: Configuration
    var onClose: (() -> Void)?
    
    // MARK: Interface configuration
    @Published var name: String
    @Published var command: String
    @Published var workingDirectory: String
    @Published var launchAutomatically: Bool
    
    var canSave: Bool {
        return !name.isEmpty && !command.isEmpty && !workingDirectory.isEmpty
    }
    
    // MARK: User interactions
    func cancel() {
        onClose?()
    }
    
    func save() {
        guard canSave else {
            return
        }
        
        process.name = name
        process.command = command
        process.workingDirectory = workingDirectory
        process.launchAutomatically = launchAutomatically
        
        do {
            try context.save()
            onClose?()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Private
    
    // MARK: Models
    private let process: ManagedProcess
    
    // MARK: Dependencies
    private let context: NSManagedObjectContext
}
