//
//  ReusableView.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by 刘畅 on 2022/8/1.
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
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with identifier: \(T.defaultReuseIdentifier) for indexPath: \(indexPath)")
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
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with identifier: \(T.defaultReuseIdentifier) for indexPath: \(indexPath)")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't dequeue view with identifier: \(T.defaultReuseIdentifier) for indexPath: \(indexPath)")
        }
        return view
    }
}
