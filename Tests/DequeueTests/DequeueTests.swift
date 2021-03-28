import XCTest
@testable import Dequeue

final class DequeueTests: XCTestCase {
    
    func testOne() {
        
        let frame = CGRect(origin: .zero, size: .init(width: 250, height: 500))
        let view = UIView(frame: frame)
        
        final class TableViewCell: UITableViewCell, DequeueableComponentIdentifiable {
            
            func update(with indexPath: IndexPath) {
                textLabel?.text = "Row \(indexPath.row + 1)"
            }
        }
        
        final class TableView: UITableView, DequeueableTableView {
            
            override init(frame: CGRect, style: UITableView.Style) {
                super.init(frame: frame, style: style)
                register(cellType: TableViewCell.self, hasXib: false)
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("Not implemented.")
            }
        }
        
        final class DataSource: NSObject, UITableViewDataSource {
            
            func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 10
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let tableView = tableView as? TableView
                XCTAssertNotNil(tableView)
                return cell(in: tableView!, for: indexPath)
            }
            
            private func cell(in tableView: TableView, for indexPath: IndexPath) -> UITableViewCell {
                let cell: TableViewCell = tableView.dequeueCell(at: indexPath)
                XCTAssertEqual(TableViewCell.dequeueableComponentIdentifier, "TableViewCellID")
                cell.update(with: indexPath)
                return cell
            }
        }
        
        let dataSource = DataSource()
        
        let tableView = TableView(frame: frame, style: .plain)
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        tableView.layoutSubviews()
    }

    static var allTests = [
        ("testOne", testOne),
    ]
}
