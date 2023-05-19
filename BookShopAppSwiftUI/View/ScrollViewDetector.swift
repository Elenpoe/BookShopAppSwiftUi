//
//  ScrollViewDetector.swift
//  BookShopAppSwiftUI
//
//  Created by Helen Poe on 12.03.2023.
//

import SwiftUI

//MARK: ScrollView detector
struct ScrollViewDetector: UIViewRepresentable {
    @Binding var carouselMode: Bool
    var totalCardCount: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) ->  UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = carouselMode ? .fast : .normal
                if carouselMode {
                    scrollView.delegate = context.coordinator
                } else {
                    scrollView.delegate = nil
                }
                
                //MARK: UpdatingTotal Count in real time
                context.coordinator.totalCount = totalCardCount
                
                print("ScrollView found")
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewDetector
       
        init(parent: ScrollViewDetector) {
            self.parent = parent
        }
        
        var totalCount: Int = 0
        var velocityY: CGFloat = 0
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
            //MARK: Removing Inalid scroll position's
            let cardHeight: CGFloat = 220
            let cardSpacing: CGFloat = 35
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocity.y * 60)
            let index = (targetEnd  / cardHeight).rounded()
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            targetContentOffset.pointee.y = modifiedEnd + spacing
            velocityY = velocity.y
        }
        
        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            let cardHeight: CGFloat = 220
            let cardSpacing: CGFloat = 35
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocityY * 60)
            let index = max(min((targetEnd  / cardHeight).rounded(), CGFloat(totalCount - 1)), 0.0)
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            scrollView.setContentOffset(.init(x: 0, y: modifiedEnd + spacing), animated: true)
        }
    }
}
