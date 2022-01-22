import AppKit

class StatusBarController {
    private unowned let popover: NSPopover
    private let statusBar: NSStatusBar
    private let statusItem: NSStatusItem

    init(popover: NSPopover) {
        self.popover = popover

        statusBar = NSStatusBar.system
        
        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(named: NSImage.Name("status_bar_icon"))
        statusItem.button?.action = #selector(togglePopover)
        statusItem.button?.target = self
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if popover.isShown {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        guard let statusBarButton = statusItem.button else {
            return
        }
        statusBarButton.highlight(true)
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        
        // Activate the app
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func hidePopover(_ sender: AnyObject) {
        statusItem.button?.highlight(false)
        popover.performClose(sender)
    }
}
