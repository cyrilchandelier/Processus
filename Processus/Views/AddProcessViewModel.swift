import Foundation
import CoreData
import SwiftUI

final class AddProcessViewModel: ObservableObject {
    // MARK: - Public API
    
    // MARK: Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: Configuration
    var onClose: (() -> Void)?
    
    // MARK: Interface configuration
    @Published var name: String = ""
    @Published var command: String = ""
    @Published var workingDirectory: String = ""
    @Published var launchAutomatically: Bool = true
    
    var canCreate: Bool {
        return !name.isEmpty && !command.isEmpty && !workingDirectory.isEmpty
    }
    
    // MARK: User interactions
    func cancel() {
        onClose?()
    }
    
    func create() {
        guard canCreate else {
            return
        }
        
        let processId = UUID().uuidString
        
        let process = ManagedProcess(context: context)
        process.id = processId
        process.name = name
        process.command = command
        process.workingDirectory = workingDirectory
        process.launchAutomatically = launchAutomatically
        
        do {
//            let label = "com.cyrilchandelier.processus.\(process.id)"
//            
//            let agentProperties = AgentProperties(
//                label: label,
//                runAtLoad: launchAutomatically,
//                workingDirectory: workingDirectory,
//                programArguments: [
//                    "/bin/bash",
//                    "--login",
//                    "-c",
//                    command
//                ],
//                standardErrorPath: "/var/log/processus/\(processId).log",
//                standardOutPath: "/var/log/processus/\(processId).log"
//            )
//            
//            struct AgentProperties: Codable {
//                let label: String
//                let runAtLoad: Bool
//                let workingDirectory: String
//                let programArguments: [String]
//                let standardErrorPath: String
//                let standardOutPath: String
//                
//                enum CodingKeys: String, CodingKey {
//                    case label = "Label"
//                    case runAtLoad = "RunAtLoad"
//                    case workingDirectory = "WorkingDirectory"
//                    case programArguments = "ProgramArguments"
//                    case standardErrorPath = "StandardErrorPath"
//                    case standardOutPath = "StandardOutPath"
//                }
//            }
//            
//            let encoder = PropertyListEncoder()
//            encoder.outputFormat = .xml
//
//            let path = FileManager
//                .default
//                .homeDirectoryForCurrentUser
//                .appendingPathComponent("Library")
//                .appendingPathComponent("LaunchAgents")
//                .appendingPathComponent("\(label).plist")
//            
//            let plist = try encoder.encode(agentProperties)
//            try plist.write(to: path)
            
            try context.save()
            
            onClose?()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Private
    
    // MARK: Dependencies
    private let context: NSManagedObjectContext
}
