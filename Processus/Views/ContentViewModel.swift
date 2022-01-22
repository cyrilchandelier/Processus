import Cocoa
import Foundation
import CoreData

final class ContentViewModel {
    // MARK: - Public API
    
    // MARK: Initializers
    init(context: NSManagedObjectContext, processService: ProcessServiceProtocol) {
        self.context = context
        self.processService = processService
    }
    
    // MARK: User actions
    func toggleRequested(for process: ManagedProcess) {
        if processService.isRunning(process: process) {
            processService.stop(process: process)
        } else {
            processService.start(process: process)
        }
    }
    
    func editRequested(for process: ManagedProcess) {
        self.editProcessWindowController?.close()
        
        let editProcessWindowController = EditProcessWindowController(process: process, context: context)
        editProcessWindowController.showWindow(nil)
        self.editProcessWindowController = editProcessWindowController
    }
    
    func deleteRequested(for process: ManagedProcess) {
        context.delete(process)

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func createProcess() {
        self.addProcessWindowController?.close()
        
        let addProcessWindowController = AddProcessWindowController(context: context)
        addProcessWindowController.showWindow(nil)
        self.addProcessWindowController = addProcessWindowController
    }
    
    func terminate() {
        NSApp.terminate(self)
    }
    
    // MARK: - Private
    
    // MARK: Dependencies
    private let context: NSManagedObjectContext
    private let processService: ProcessServiceProtocol
    
    private var addProcessWindowController: AddProcessWindowController?
    private var editProcessWindowController: EditProcessWindowController?
}
