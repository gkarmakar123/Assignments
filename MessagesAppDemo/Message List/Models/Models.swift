//
//  MessageModel.swift
//  MessagesAppDemo
//
//  Created by Gaurav Karmakar on 14/02/21.
//

import Foundation

struct MessageMainModel: Codable {
    var messageModels: [MessageModel]!
    var messageModelsBackup: [MessageModel]!
    var totalPinnedMessages: Int = 0
    var allInEditMode:Bool = false {
        didSet {
            for i in 0..<messageModels.count {
                messageModels[i].inEditMode = allInEditMode
            }
        }
    }
}

extension MessageMainModel {
    enum CodingKeys: String, CodingKey {
        case messageModels = "messageListData"
    }
}

//MARK:- Individual Message Model
struct MessageModel: Codable, Hashable {
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

