import UIKit
private let visibleCellCount = 5

class RLBCardsLayout: UICollectionViewLayout {
    /**
     Toggles invalidating layout on bounds change behavior.
     Used as a workaround for an issue when the collection view is contained inside a UINavigationController and the scrolling stops between pages when the view is popped or pushed.
    */
	var invalidateOnBoundsChange = true //use sparingly?
        {
        didSet {
            if !oldValue && invalidateOnBoundsChange {
                invalidateLayout()
            }
        }
    }
	
	fileprivate var normalItemSize = CGSize.zero {
		didSet {
			guard oldValue != normalItemSize else { return }
			attributesByIndexPath.removeAll()
		}
	}
	
	override func prepare() {
		super.prepare()
		guard let collectionView = collectionView else { return }
		
		let bounds = collectionView.bounds
		let size: CGSize
		if (bounds.height / (bounds.width - 60)) > 1.22 {
			let width = (bounds.width - 60)
			size = CGSize(width: width, height: ceil(width * 1.22))
		} else {
			size = CGSize(width: ceil(bounds.height/1.22), height: bounds.height)
		}
		normalItemSize = size
		
	}
	
	override var collectionViewContentSize : CGSize {
		guard let collectionView = collectionView else { return CGSize.zero }
		let bounds = collectionView.bounds
		let itemCount = (0..<collectionView.numberOfSections).reduce(0) { $0 + collectionView.numberOfItems(inSection: $1) }
		return CGSize(width: bounds.width, height: CGFloat(itemCount) * bounds.height)
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let collectionView = collectionView, collectionView.contentSize == collectionViewContentSize else { return nil }
		let bounds = collectionView.bounds
		let frontRow = max(Int((bounds.maxY-1)/bounds.height), 0 )
		let threeBack = max(frontRow - visibleCellCount, 0)
		let attributes = (threeBack...frontRow).flatMap { row -> UICollectionViewLayoutAttributes? in
			guard let indexPath = indexPathForIndex(row) else { return nil }
			return layoutAttributesForItem(at: indexPath)
		}
		return attributes
	}
	
	fileprivate func indexPathForIndex(_ index: Int) -> IndexPath? {
		guard let collectionView = collectionView else { return nil }
		var cursor = index
		for section in 0..<collectionView.numberOfSections {
			let itemCount = collectionView.numberOfItems(inSection: section)
			if cursor < itemCount {
				return IndexPath(item: cursor, section: section)
			} else {
				cursor -= itemCount
			}
		}
		return nil
	}
	
	fileprivate func indexForIndexPath(_ indexPath: IndexPath) -> Int {
		guard let collectionView = collectionView else { return 0 }
		var index = 0
		for section in 0..<indexPath.section {
			index += collectionView.numberOfItems(inSection: section)
		}
		index += indexPath.row
		return index
	}
	
	fileprivate var attributesByIndexPath: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		guard let collectionView = collectionView else { return nil }
		
		let attributes: UICollectionViewLayoutAttributes
		if let cachedAttr = attributesByIndexPath[indexPath] {
			attributes = cachedAttr
		} else {
			attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		}
		
		let bounds = collectionView.bounds
		let index = indexForIndexPath(indexPath)
		let frontIndex = Int((bounds.maxY)/bounds.height)
		let backIndex = max(frontIndex - visibleCellCount, 0)
		guard index >= backIndex && index <= frontIndex else {
			attributes.isHidden = true
			return attributes
		}
		
		let size = normalItemSize
		let origin = CGPoint(x: bounds.midX - size.width/2, y: bounds.midY - size.height/2)
		attributes.frame = CGRect(origin: origin, size: size)
		attributes.zIndex = index
		
		
		var transform = CATransform3DIdentity
		let ratio = (bounds.minY - (bounds.height * CGFloat(index)))/bounds.height
		transform.m34 = 1.0 / -1000
		if index == frontIndex {
			let angle = CGFloat(M_PI_2) * (ratio)
			let radius = size.height/2
			transform = CATransform3DTranslate(transform, 0, (1-cos(angle))*radius, 0)
			transform = CATransform3DTranslate(transform, 0, 0, -sin(angle)*radius)
			transform = CATransform3DRotate(transform, angle, 1, 0, 0)
			attributes.transform3D = transform
			attributes.alpha = 1+ratio
		} else {
			let delta = ratio * floor(size.height/40) * CGFloat(visibleCellCount)
			transform = CATransform3DTranslate(transform, 0, 0, -(ratio * 140))
			transform = CATransform3DTranslate(transform, 0, -delta, 0)
			attributes.transform3D = transform
			attributes.alpha = 1 - (ratio/CGFloat(visibleCellCount))
		}
		return attributes
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return invalidateOnBoundsChange
	}
}
