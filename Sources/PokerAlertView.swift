//
//  PokerAlertView.swift
//  PokerCard
//
//  Created by Weslie on 2019/9/11.
//  Copyright © 2019 Weslie (https://www.iweslie.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

/// Base Poker Alert View
public class PokerAlertView: PokerView, PokerTitleRepresentable, PokerConfirmRepresentable {
    
    /// Title label for an alertView
    public var titleLabel: UILabel = PKLabel(fontSize: 22)
    /// Detail label for an alertView
    public var detailLabel: UILabel?
    /// Confirm button for an alertView
    public var confirmButton: UIButton = PKButton(title: "", fontSize: 20)
    internal var cancelButton = PKButton(title: "", fontSize: 14)
    
    internal var titleHorizontalInset: CGFloat = 24
    internal var titleVerticalInset: CGFloat = 18
    internal var detailHorizontalInset: CGFloat = 15
    internal var lineSpacing: CGFloat = 8
    
    internal var titleBDetailTCons: NSLayoutConstraint?
    internal var titleBConfirmTCons: NSLayoutConstraint!
    internal var detailBConfirmTCons: NSLayoutConstraint!
    
    public convenience init(title: String, detail: String? = nil) {
        self.init()
        
        frame.size.width = 265
        frame.size.height = 134
        
        titleLabel = setupTitleLabel(for: self, with: title)
        confirmButton = setupConfirmButton(for: self, with: "Confirm")
        titleBConfirmTCons = confirmButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleVerticalInset)
        titleBConfirmTCons.priority = .defaultHigh
        titleBConfirmTCons.isActive = true
        
        setupDetail(with: detail)
    }
    
    public override func layoutSubviews() {
        // TODO: - fix bug, do not use this 
        super.layoutSubviews()
        _ = layoutViews
    }
    
    private lazy var layoutViews: Void = {
        confirmButton.layer.cornerRadius = confirmButton.frame.height / 2
        
        // resize title label
        // offset = estimated - original
        //
        // height = height - original + estimated
        // height -= original - estimated
        frame.size.height -= titleLabel.frame.height - titleLabel.estimatedHeight(for: titleHorizontalInset)
        if let detailLabel = detailLabel {
            frame.size.height -= detailLabel.frame.height - detailLabel.estimatedHeight(for: detailHorizontalInset)
        }
    }()
    
    private func setupDetail(with detail: String?) {
        guard let detail = detail, !detail.isEmpty else { return }
        
        let label = PKLabel(fontSize: 14)
        
        label.text = detail
        label.textAlignment = label.numberOfLines == 1 ? .center : .left
        addSubview(label)
        detailLabel = label
        
        titleBDetailTCons = label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        titleBDetailTCons?.isActive = true
        label.constraint(withLeadingTrailing: detailHorizontalInset)
        
        detailBConfirmTCons = label.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -12)
        detailBConfirmTCons?.priority = .defaultHigh
        detailBConfirmTCons?.isActive = true
        
        titleBConfirmTCons.isActive = false
    }
    
    func setupCancelButton(with title: String?) {
        guard let cancelTitle = title, !cancelTitle.isEmpty else {
            confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
            return
        }
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.setTitleColor(PKColor.cancel, for: .normal)
        addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 88).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
}
