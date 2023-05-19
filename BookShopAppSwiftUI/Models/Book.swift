//
//  Book.swift
//  BookShopAppSwiftUI
//
//  Created by Helen Poe on 07.03.2023.
//

import SwiftUI

/// <#Description#>
struct Book: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var imageName: String
    var autor: String
    var rating: Int
    var bookViews: Int
    
}

var samplBooks: [Book] = [
    .init(title: "Some kind of happiness", imageName: "0book", autor: "Claire Legrand", rating: 5, bookViews: 734),
    .init(title: "On a sunbeam", imageName: "1book", autor: "Tilly Walden", rating: 3, bookViews: 789),
    .init(title: "Are you listening?", imageName: "2book", autor: "Tilly Walden", rating: 4, bookViews: 1098),
    .init(title: "How I stopped being hopeless", imageName: "3book", autor: "Nora Lee", rating: 5, bookViews: 378),
    .init(title: "Starlight", imageName: "4book", autor: "Vintage Gibbons", rating: 4, bookViews: 876),
    .init(title: "The hidden ways", imageName: "5book", autor: "Alistair Moffat", rating: 4, bookViews: 596)
]
