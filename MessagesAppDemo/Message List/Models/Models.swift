//
//  MessageModel.swift
//  MessagesAppDemo
//
//  Created by Gaurav Karmakar on 14/02/21.
//

import Foundation

class MessageModels: Codable {
    var messageListData: [MessageModel]
    var totalPinnedMessages: Int = 0
    var allInEditMode:Bool = false {
        didSet {
            for i in 0..<messageListData.count {
                messageListData[i].inEditMode = allInEditMode
            }
        }
    }
}

extension MessageModels {
    enum CodingKeys: CodingKey {
        case messageListData
    }
}

//MARK:- Individual Message Model
class MessageModel: Codable, Hashable {
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.messageID == rhs.messageID
    }
    
    var messageID: Int
    var senderImageURL: String
    var senderName: String
    var lastMessage: String
    var lastMessageUnread: Bool
    var lastMessageDate: String
    var isPinned = false
    var inEditMode = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageID)
    }
}

extension MessageModel {
    enum CodingKeys: CodingKey {
        case messageID
        case senderImageURL
        case senderName
        case lastMessage
        case lastMessageUnread
        case lastMessageDate
    }
}

