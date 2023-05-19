//
//  RatingView.swift
//  BookShopAppSwiftUI
//
//  Created by Helen Poe on 12.03.2023.
//

import SwiftUI

//MARK: Custom rating View
struct RatingView: View {
    var rating: Int
    var body: some View {
        HStack(spacing: 4){
            ForEach(0...5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(index <= rating ? .yellow : .gray.opacity(0.5))
            }
            Text("(\(rating))")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
                .padding(.leading, 5)
        }
    }
}
