import Cocoa
import SwiftUI

final class AddProcessWindowController: NSWindowController {
    convenience init(context: NSManagedObjectContext) {
        let rootViewModel = AddProcessViewModel(context: context)
        let rootView = AddProcessView(viewModel: rootViewModel)
        
        let hostingController = NSHostingController(rootView: rootView)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Create Process"
        window.setContentSize(NSSize(width: 320, height: 400))

        self.init(window: window)
        
        window.delegate = self

        rootViewModel.onClose = { [weak self] in
            self?.close()
        }
    }
}

extension AddProcessWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        self.window = nil
    }
}
