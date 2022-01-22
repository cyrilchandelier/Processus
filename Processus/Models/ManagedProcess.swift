import CoreData

@objc(ManagedProcess)
final class ManagedProcess: NSManagedObject, Identifiable {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var command: String
    @NSManaged var workingDirectory: String
    @NSManaged var launchAutomatically: Bool
    @NSManaged var isRunning: Bool
}
