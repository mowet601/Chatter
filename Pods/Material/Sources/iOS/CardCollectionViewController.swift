/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

extension UIViewController {
  /**
   A convenience property that provides access to the CardCollectionViewController.
   This is the recommended method of accessing the CardCollectionViewController
   through child UIViewControllers.
   */
  public var cardCollectionViewController: CardCollectionViewController? {
    var viewController: UIViewController? = self
    while nil != viewController {
      if viewController is CardCollectionViewController {
        return viewController as? CardCollectionViewController
      }
      viewController = viewController?.parent
    }
    return nil
  }
}

open class CardCollectionViewController: UIViewController {
  /// A reference to a Reminder.
  open let collectionView = CollectionView()
  
  open var dataSourceItems = [DataSourceItem]()
  
  /// An index of IndexPath to DataSourceItem.
  open var dataSourceItemsIndexPaths = [IndexPath: Any]()
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    prepare()
  }
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layoutSubviews()
  }
  
  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepareView method
   to initialize property values and other setup operations.
   The super.prepareView method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    view.clipsToBounds = true
    view.backgroundColor = .white
    view.contentScaleFactor = Screen.scale
    prepareCollectionView()
  }
  
  /// Calls the layout functions for the view heirarchy.
  open func layoutSubviews() {
    layoutCollectionView()
  }
}

extension CardCollectionViewController {
  /// Prepares the collectionView.
  fileprivate func prepareCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCollectionViewCell")
    view.addSubview(collectionView)
    layoutCollectionView()
  }
}

extension CardCollectionViewController {
  /// Sets the frame for the collectionView.
  fileprivate func layoutCollectionView() {
    collectionView.frame = view.bounds
  }
}

extension CardCollectionViewController: CollectionViewDelegate {}

extension CardCollectionViewController: CollectionViewDataSource {
  @objc
  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  @objc
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSourceItems.count
  }
  
  @objc
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
    
    guard let card = dataSourceItems[indexPath.item].data as? Card else {
      return cell
    }
    
    dataSourceItemsIndexPaths[indexPath] = card
    
    card.frame = cell.bounds
    
    cell.card = card
    
    return cell
  }
}

