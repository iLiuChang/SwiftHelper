//
//  ReusableView.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 2022/8/1.
//  Copyright © 2022 LiuChang. All rights reserved.
//

import UIKit

public protocol ReusableView {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionReusableView: ReusableView {}

public extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type, fromNib: Bool = false) {
        if fromNib {
            register(UINib(nibName: cellClass.defaultReuseIdentifier, bundle: nil),
                     forCellReuseIdentifier: cellClass.defaultReuseIdentifier)
        } else {
            register(cellClass,
                     forCellReuseIdentifier: cellClass.defaultReuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
      guard let cell = dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier, for: indexPath) as? T else {
        fatalError("Couldn't dequeue cell with identifier: \(cellClass.defaultReuseIdentifier) for indexPath: \(indexPath)")
      }
      return cell
    }
}


public extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type, fromNib: Bool = false) {
        if fromNib {
            register(UINib(nibName: cellClass.defaultReuseIdentifier, bundle: nil),
                     forCellWithReuseIdentifier: cellClass.defaultReuseIdentifier)
        } else {
            register(cellClass,
                     forCellWithReuseIdentifier: cellClass.defaultReuseIdentifier)
        }
    }
    
    func register<T: UICollectionReusableView>(_ viewClass: T.Type, forSupplementaryViewOfKind elementKind: String, fromNib: Bool = false) {
        if fromNib {
            register(UINib(nibName: viewClass.defaultReuseIdentifier, bundle: nil),
                     forSupplementaryViewOfKind: elementKind,
                     withReuseIdentifier: viewClass.defaultReuseIdentifier)
        } else {
            register(viewClass,
                     forSupplementaryViewOfKind: elementKind,
                     withReuseIdentifier: viewClass.defaultReuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
      guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.defaultReuseIdentifier, for: indexPath) as? T else {
        fatalError("Couldn't dequeue cell with identifier: \(cellClass.defaultReuseIdentifier) for indexPath: \(indexPath)")
      }
      return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, viewClass: T.Type, for indexPath: IndexPath) -> T {
      guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: viewClass.defaultReuseIdentifier, for: indexPath) as? T else {
        fatalError("Couldn't dequeue view with identifier: \(viewClass.defaultReuseIdentifier) for indexPath: \(indexPath)")
      }
      return view
    }
}
