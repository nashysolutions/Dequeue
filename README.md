# Dequeue

A wrapper for UI elements that dequeue cells. Cells are dequeued by their corresponding type.

## Usage

This is a *full implementation* that assumes you are *not* using interface building.

```swift
import UIKit
import Dequeue

final class TableViewCell: UITableViewCell, DequeableComponentIdentifiable {}

final class TableView: UITableView, DequeableTableView {}

final class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView = TableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(cellType: TableViewCell.self, hasXib: false)
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? DequeableTableView else { 
            fatalError("Ooops. Missed a step.")
        }
        return cell(in: tableView, at: indexPath)
    }
    
    private func cell(in tableView: DequeableTableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueCell(at: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
}
```

### Interface Builder

If you are using interface builder, then these addtiional implementation steps are required.

* Make sure your source files and your interface builder files are in the same bundle and have matching names.
* You will need to specify reuse identifiers *in your interface builder files*, for each cell you build. This should be the classname of the cell subclass, plus `ID`. For example `MyTableViewCellID`.
* If you have prepared a cell using a `.xib` then you will need to pass true here.

```swift
tableView.register(cellType: TableViewCell.self, hasXib: true)
```
> N.B. You do not need to register if you are using a storyboard.
