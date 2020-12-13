//
//  BuyNFC.swift
//  TapShare2
//
//  Created by Ari Wasch on 10/13/20.
//

import Foundation
import UIKit

class BuyNFC: UIViewController, UITextViewDelegate{

    @IBOutlet weak var textBoi: UITextView!
    override func viewDidLoad() {
        textBoi.text = "In order to use the NFC features on TapLink, you must have an NFC Chip. You can purchase NFC chip stickers for less than $0.50 each at @shopNFC or @amazon. The image below shows where to place the NFC sticker for different purposes."
        textBoi.attributedText = textBoi.attributedText?.replace(placeholder: "@shopNFC", with: "ShopNFC", url: "https://www.shopnfc.com/en/7-nfc-stickers")
        textBoi.attributedText = textBoi.attributedText?.replace(placeholder: "@amazon", with: "Amazon", url: "https://www.amazon.com/NTAG215-NFC-Tags-25mm-1inch-Programmable/dp/B08927KXV6/ref=sr_1_5?dchild=1&keywords=NFC+chip+stickers&qid=1602618671&sr=8-5")
                super.viewDidLoad()
//        textBoi.linkTextAttributes = NSAtt
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    func resizeFont(_ textView: UITextView) {
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
                  return;
              }

              let textViewSize = textView.frame.size;
              let fixedWidth = textViewSize.width;
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));

              var expectFont = textView.font;
              if (expectSize.height > textViewSize.height) {
                while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                  expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                      textView.font = expectFont
                  }
              }
              else {
                while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                      expectFont = textView.font;
                    textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
                  }
                  textView.font = expectFont;
              }

      }



}
extension NSAttributedString {
    func replace(placeholder: String, with hyperlink: String, url: String) -> NSAttributedString {
        let mutableAttr = NSMutableAttributedString(attributedString: self)

        let hyperlinkAttr = NSAttributedString(string: hyperlink, attributes: [NSAttributedString.Key.backgroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.9
        
        ),
            NSAttributedString.Key.link: URL(string: url)!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
    
        let placeholderRange = (self.string as NSString).range(of: placeholder)
        
        mutableAttr.replaceCharacters(in: placeholderRange, with: hyperlinkAttr)
        return mutableAttr
    }
}
