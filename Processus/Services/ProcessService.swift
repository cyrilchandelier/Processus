import Foundation
import CoreData

protocol ProcessServiceProtocol {
    func isRunning(process: ManagedProcess) -> Bool
    func start(process: ManagedProcess)
    func stop(process: ManagedProcess)
    
    func startInitialTasks()
    func stopAllTasks()
}

final class ProcessService: ProcessServiceProtocol {
    // MARK: - Public API

    // MARK: Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: Processes state management
    func isRunning(process: ManagedProcess) -> Bool {
        tasks[process.id] != nil
    }

    func startInitialTasks() {
        let request = NSFetchRequest<ManagedProcess>(entityName: "ManagedProcess")
        request.predicate = NSPredicate(format: "%K = %d", "launchAutomatically", true)
        do {
            let processes = try context.fetch(request)
            processes.forEach(start)
        } catch {
            print(String(describing: error))
        }
    }

    func start(process: ManagedProcess) {
        let processId = process.id
        let managedObjectId = process.objectID
        DispatchQueue.global(qos: .background).async {
            self.executeTask(processId: processId, managedObjectId: managedObjectId)
        }
    }

    func stop(process: ManagedProcess) {
        let processId = process.id

        // Ensure the task was started
        guard let task = tasks[processId] else {
            return
        }

        // Terminate task
        if task.process.isRunning {
            task.process.terminationHandler = nil // Prevent default behavior to crash the app
            task.process.terminate()
        }

        // Remove it from held tasks
        tasks.removeValue(forKey: processId)

        // Mark the process as not running
        process.isRunning = false
        do {
            try context.save()
        } catch {
            print(String(describing: error))
        }
    }

    func stopAllTasks() {
        for (_, task) in tasks {
            task.process.terminate()
        }
    }
    
    // MARK: - Private
    
    // MARK: Task management
    private func executeTask(processId: String, managedObjectId: NSManagedObjectID) {
        do {
            let managedProcess: ManagedProcess = context.object(with: managedObjectId) as! ManagedProcess
            
            // Prepare process
            let process = Process()
            process.launchPath = "/bin/bash"
            process.arguments = [
                "--login",
                "-c",
                "cd \(managedProcess.workingDirectory); \(managedProcess.command)"
            ]

            // Handle process termination
            process.terminationHandler = { [weak self] process in
                guard let managedProcess = self?.context.object(with: managedObjectId) as? ManagedProcess else {
                    return
                }
                managedProcess.isRunning = false
                do {
                    try self?.context.save()
                } catch {
                    print(error.localizedDescription)
                }

                // Store task for future references
                self?.tasks.removeValue(forKey: processId)
            }

            // Launch process
            try process.run()

            // Mark the process as running
            managedProcess.isRunning = true
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }

            // Store task for future references
            tasks[processId] = Task(managedObjectId: managedObjectId, process: process)
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: Dependencies
    private let context: NSManagedObjectContext
    private var tasks: [String: Task] = [:]
}

struct Task {
    let managedObjectId: NSManagedObjectID
    let process: Process
}
