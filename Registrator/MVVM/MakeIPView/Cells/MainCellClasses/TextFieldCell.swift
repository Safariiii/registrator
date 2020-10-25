//
//  TextFieldCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class TextFieldCell: BasicCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        pickerView?.removeFromSuperview()
        textField = TextFieldView()
        addSubview(textField!)
        textField!.isUserInteractionEnabled = true
    }
    
    var pickerView: UIPickerView?
    var note: UIButton?
    var noteLabel: UILabelPadding?
    fileprivate var extraLayer: UIView?
    
    func setupNotes() {
        note = UIButton(action: #selector(notePressed), target: self, fontSize: 8, numberOfLines: 0, image:  UIImage(systemName: "questionmark.circle"))
        guard let note = note else { return }
        addSubview(note)
        note.setupAnchors(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, centerY: centerYAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -15))
        setupNoteLabel()
    }
    
    fileprivate func setupNoteLabel() {
        noteLabel = UILabelPadding(textColor: .black, fontSize: 14, alignment: .left, numberOfLines: 0)
        noteLabel?.backgroundColor = .systemGray5
        noteLabel?.clipsToBounds = true
        noteLabel?.layer.cornerRadius = 6
    }
    
    @objc func notePressed() {
        extraLayer = UIView()
        guard let extraView = extraLayer, let label = noteLabel else { return }
        let tableview = superview as! UITableView
        let vc: UIViewController?
        if let viewCont = tableview.dataSource as? MakeIPViewController {
            vc = viewCont
        } else {
            vc = tableview.dataSource as? AddressView
        }
        if let view = vc?.view {
            view.addSubview(extraView)
            extraView.fillSuperview()
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissNote))
            extraView.addGestureRecognizer(tap)
            addSubview(label)
            label.setupAnchors(top: note?.topAnchor, leading: leadingAnchor, bottom: nil, trailing: note?.leadingAnchor, padding: .init(top: 0, left: 80, bottom: 0, right: -8))
        }
    }
    
    @objc func dismissNote() {
        noteLabel?.removeFromSuperview()
        extraLayer?.removeFromSuperview()
    }
}
