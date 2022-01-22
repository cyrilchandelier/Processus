import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var popover: NSPopover?
    private var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let viewContext = persistenceController.container.viewContext
        
        let contentViewModel = ContentViewModel(context: viewContext, processService: processService)
        let contentView = ContentView(viewModel: contentViewModel)
            .environment(\.managedObjectContext, viewContext)
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.behavior = .transient
        self.popover = popover

        statusBarController = StatusBarController(popover: popover)
        
        processService.startInitialTasks()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        processService.stopAllTasks()
    }
    
    // MARK: - Dependencies
    private let persistenceController: PersistenceController = PersistenceController.shared
    private lazy var processService: ProcessServiceProtocol = ProcessService(
        context: persistenceController.container.viewContext
    )
}
