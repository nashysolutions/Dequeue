//  Created by Rob Nash on 02/03/2020.
//  Copyright © 2020 Nash Property Solutions Ltd. All rights reserved.
//

import UIKit

// MARK: DequeueableComponentIdentifiable

/// A type that can identify itself to a dequeueable view.
public protocol DequeueableComponentIdentifiable: AnyObject {
    
    /// The reuse identifier to use for dequeueing a cell.
    static var dequeueableComponentIdentifier: String { get }
}

public extension DequeueableComponentIdentifiable {
    
    static var dequeueableComponentIdentifier: String {
        return "\(Self.self)" + "ID"
    }
    
}

// MARK: Dequeueable

/// A type that is eligable for registration as a dequeueable component.
public protocol Dequeueable {
    
    /**
     Register a class for use as a cell.
     
     - Attention: If you are using a .storyboard for your cell, there is no need to call this function.
     - Important: If you are using a .xib file for your cell and you pass `true` for the parameter `hasXib`, an exception will be thrown at runtime in *UIKit* if the .xib file is not stored in the same bundle, and has the same filename, as it's complementary source code file.
     - Parameters:
       - cellType: The class type to register.
       - hasXib: Indicates that the cell has a complementary .xib file.
    */
    func register(cellType: DequeueableComponentIdentifiable.Type, hasXib: Bool)
}

public extension Dequeueable where Self: UITableView {
    
    func register(cellType: DequeueableComponentIdentifiable.Type, hasXib: Bool) {
        let identifier = cellType.dequeueableComponentIdentifier
        if hasXib == true {
            let nib = UINib(nibName: "\(cellType)", bundle: Bundle(for: cellType))
            register(nib, forCellReuseIdentifier: identifier)
        } else {
            register(cellType, forCellReuseIdentifier: identifier)
        }
    }
}

public extension Dequeueable where Self: UICollectionView {
    
    func register(cellType: DequeueableComponentIdentifiable.Type, hasXib: Bool) {
        let identifier = cellType.dequeueableComponentIdentifier
        if hasXib == true {
            let nib = UINib(nibName: "\(cellType)", bundle: Bundle(for: cellType))
            register(nib, forCellWithReuseIdentifier: identifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: identifier)
        }
    }
}

// MARK: DequeueableTableView

// A dequeueable componenet where Self is expected to be a UITableView.
public protocol DequeueableTableView: Dequeueable {
    
    /**
     Register a class for use as a section header or section footer view.
     
     - Important: If you are using a .xib file and the .xib file is not stored in the same bundle as it's complementary source code file, an exception will be thrown at runtime in *UIKit*.
     - Parameters:
     - headerFooterViewType: The class type to register.
     - hasXib: Indicates that the view has a complementary .xib file.
     */
    func register(headerFooterViewType: DequeueableComponentIdentifiable.Type, hasXib: Bool)
    
    /**
     Provides a view.
     - Important: Before using this function, you must register a class for use as a section header or section footer view.
     - Returns: A view.
    */
    func dequeueHeaderFooterView<T>() -> T where T : UITableViewHeaderFooterView & DequeueableComponentIdentifiable
    
    /**
     Provides a cell.
     - Important: Before using this function, you must register a class for use as a cell.
     - Parameter indexPath: The position of the cell.
     - Returns: A cell.
     */
    func dequeueCell<T>(at indexPath: IndexPath) -> T where T : UITableViewCell & DequeueableComponentIdentifiable
}

public extension DequeueableTableView where Self: UITableView {
    
    func register(headerFooterViewType: DequeueableComponentIdentifiable.Type, hasXib: Bool) {
        let identifier = headerFooterViewType.dequeueableComponentIdentifier
        if hasXib == true {
            let bundle = Bundle(for: headerFooterViewType)
            let nib = UINib(nibName: "\(headerFooterViewType)", bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        } else {
            register(headerFooterViewType, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    func dequeueHeaderFooterView<T>() -> T where T : UITableViewHeaderFooterView & DequeueableComponentIdentifiable {
        return dequeueReusableHeaderFooterView(withIdentifier: T.dequeueableComponentIdentifier) as! T
    }
    
    func dequeueCell<T>(at indexPath: IndexPath) -> T where T : UITableViewCell & DequeueableComponentIdentifiable {
        return dequeueReusableCell(withIdentifier: T.dequeueableComponentIdentifier, for: indexPath) as! T
    }
}

// MARK: DequeueableCollectionView

// A dequeueable componenet where Self is expected to be a UICollectionView.
public protocol DequeueableCollectionView: Dequeueable {
    
    /**
     Register a class for use as a section header or section footer view.
     
     - Important: If you are using a .xib file and the .xib file is not stored in the same bundle as it's complementary source code file, an exception will be thrown at runtime in *UIKit*.
     - Requires: kind == UICollectionView.elementKindSectionHeader or kind == UICollectionView.elementKindSectionFooter
     - Parameters:
     - headerFooterViewType: The class type to register.
     - kind: The kind of supplementary view to register.
     - hasXib: Indicates that the view has a complementary .xib file.
     */
    func register(headerFooterViewType: DequeueableComponentIdentifiable.Type, forSupplementaryViewOfKind kind: String, hasXib: Bool)
    
    /**
     Provides a view.
    
     - Important: Before using this function, you must register a class for use as a section header or section footer view.
     - Requires: kind == UICollectionView.elementKindSectionHeader or kind == UICollectionView.elementKindSectionFooter
     - Parameters:
       - indexPath: The position of the view.
       - kind: The kind of supplementary view to provide.
     - Returns: A view.
     
    */
    func dequeueSupplementaryView<T>(at indexPath: IndexPath, ofKind kind: String) -> T where T : UICollectionReusableView & DequeueableComponentIdentifiable
    
    /**
     Provides a cell.
     - Important: Before using this function, you must register a class for use as a cell.
     - Returns: A cell.
     */
    func dequeueCell<T>(at indexPath: IndexPath) -> T where T : UICollectionViewCell & DequeueableComponentIdentifiable
}

public extension DequeueableCollectionView where Self: UICollectionView {
    
    func register(headerFooterViewType: DequeueableComponentIdentifiable.Type, forSupplementaryViewOfKind kind: String, hasXib: Bool) {
        let identifier = headerFooterViewType.dequeueableComponentIdentifier
        if hasXib == true {
            let nib = UINib(nibName: "\(headerFooterViewType)", bundle: Bundle(for: headerFooterViewType))
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        } else {
            register(headerFooterViewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }
    
    func dequeueSupplementaryView<T>(at indexPath: IndexPath, ofKind kind: String) -> T where T : UICollectionReusableView & DequeueableComponentIdentifiable {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.dequeueableComponentIdentifier, for: indexPath) as! T
    }
    
    func dequeueCell<T>(at indexPath: IndexPath) -> T where T : UICollectionViewCell & DequeueableComponentIdentifiable {
        return dequeueReusableCell(withReuseIdentifier: T.dequeueableComponentIdentifier, for: indexPath) as! T
    }
}
