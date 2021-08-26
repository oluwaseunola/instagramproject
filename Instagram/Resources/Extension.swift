//
//  Extension.swift
//  InstaApp
//
//  Created by Seun Olalekan on 2021-06-13.
//

import UIKit

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
    
    
    
    
}

extension String {
    
    func safeEmail() -> String{
        
        return self.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        
    }
    
}

extension Decodable{
    init?(with dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {return nil}
        guard let result = try? JSONDecoder().decode(Self.self, from: data) else{return nil}
        
        self = result
        
        
        
    }
}

extension Encodable{
    
    func makeDictionary() -> [String: Any]? {
        
        do{ guard let data = try? JSONEncoder().encode(self) else{
            return nil}
            
            let json = try? JSONSerialization.jsonObject(with: data , options: .fragmentsAllowed) as? [String : Any]
            
            return json
        }
         
    }
    
}

extension DateFormatter{
    static let formatter : DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        
        return formatter
    }()
    
}

extension Date {
    
    func makeDate(date: Date) -> String?{
        
        let formatter = DateFormatter.formatter
        let string = formatter.string(from: date)
    
        
    
        return string
    }
}

extension Notification.Name {
    
    static let didPostNotification = Notification.Name("didPostNotification")
}

extension NSMutableAttributedString{
    var fontSize:CGFloat { return 16 }
    var boldFont:UIFont { return UIFont(name: "SF-Pro", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "SF-Pro", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {
            
            let attributes:[NSAttributedString.Key : Any] = [
                .font : boldFont
            ]
            
            self.append(NSAttributedString(string: value, attributes:attributes))
            return self
        }
    
       func normal(_ value:String) -> NSMutableAttributedString {
           
           let attributes:[NSAttributedString.Key : Any] = [
               .font : normalFont,
           ]
           
           self.append(NSAttributedString(string: value, attributes:attributes))
           return self
       }
}

extension Array{
    
    
    func find(array:[String] ,item: String)-> Int{
        
        for (index, value) in array.enumerated(){
            
            if item == value{
                return index
                
            }
            
        }
        return 0
    }
}
