//
//  String+Pinyin.swift
//  TestKit
//
//  Created by zbt on 2022/10/27.
//

import Foundation
//判断字符串首字符是否为英文
extension Character {
    var isAsciiLetter: Bool { "A"..."Z" ~= self || "a"..."z" ~= self }
}

extension StringProtocol {
    var startsWithAsciiLetter: Bool { first?.isAsciiLetter == true }
}
extension Bool {
    var negated: Bool { !self }
}

//let nonAlphabetItems = items.filter(\.name.startsWithAsciiLetter.negated)   // [{name "123"}]

//获取拼音首字母（大写字母）
func findFirstLetterFromString(aString: String) -> String {
    //转变成可变字符串
    let mutableString = NSMutableString.init(string: aString)

    //将中文转换成带声调的拼音
    CFStringTransform(mutableString as CFMutableString, nil,      kCFStringTransformToLatin, false)

    //去掉声调
    let pinyinString = mutableString.folding(options:          String.CompareOptions.diacriticInsensitive, locale:   NSLocale.current)

    //将拼音首字母换成大写
    let strPinYin = polyphoneStringHandle(nameString: aString,    pinyinString: pinyinString).uppercased()

    //截取大写首字母
    let firstString = strPinYin.substring(to:     strPinYin.index(strPinYin.startIndex, offsetBy: 1))

    //判断首字母是否为大写
    let regexA = "^[A-Z]$"
    let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
    return predA.evaluate(with: firstString) ? firstString : "#"
}

//多音字处理，根据需要添自行加
func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
    if nameString.hasPrefix("长") {return "chang"}
    if nameString.hasPrefix("沈") {return "shen"}
    if nameString.hasPrefix("厦") {return "xia"}
    if nameString.hasPrefix("地") {return "di"}
    if nameString.hasPrefix("重") {return "chong"}
    return pinyinString
}

//取中文首字母
func pinyin(_ string:String?, _ allFirst:Bool=false)->String{
   var py="#"
   if let s = string {
       if s == "" {
           return py
       }
       let str = CFStringCreateMutableCopy(nil, 0, s as CFString)
       CFStringTransform(str, nil, kCFStringTransformToLatin,false)
       CFStringTransform(str, nil, kCFStringTransformStripCombiningMarks, false)
       py = ""
       if allFirst {
           for x in (str! as String).components(separatedBy: " "){
               py += pinyin(x)
           }
       } else {
           py  = (str! as String).prefix(1).uppercased()
       }
   }
   return py
}
