//
//  DetailView.swift
//  BookShopAppSwiftUI
//
//  Created by Helen Poe on 12.03.2023.
//

import SwiftUI

struct DetailView: View {
    @Binding var show: Bool
    var animation: Namespace.ID
    var book: Book
    //MARK: View properties
    @State private var animateContent: Bool = false
    @State private var offsetAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    offsetAnimation = false
                }
                
                withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                    animateContent = false
                    show = false
                }
                print("CloseButton on")
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .contentShape(Rectangle())
            }
            .padding([.leading, .vertical], 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(animateContent ? 1 : 0)
            
            //MARK: Book Preview (with matched geometry effet)
            GeometryReader{
                let size = $0.size
                
                HStack(spacing: 20){
                    Image(book.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (size.width - 30) / 2, height: size.height)
                        //MARK: Custom corner shape
                        .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                        //MARK: Mathed Geometry ID
                        .matchedGeometryEffect(id: book.id, in: animation)
                   
                    VStack(alignment: .leading, spacing: 8) {
                        Text(book.title)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("By \(book.autor)")
                            .font(.callout)
                            .foregroundColor(.gray)
                        
                        RatingView(rating: book.rating)
                    }
                    .padding(.trailing, 15)
                    .padding(.top, 30)
                    .offset(y: offsetAnimation ? 0 : 100)
                    .opacity(offsetAnimation ? 1 : 0)
                    
                }
            }
            .frame(height: 220)
            .zIndex(1)
            
            Rectangle()
                .fill(.gray.opacity(0.04))
                .ignoresSafeArea()
                .overlay(alignment: .top){
                    BookDetails()
                }
                .padding(.leading, 30)
                .padding(.top, -180)
                .zIndex(0)
                .opacity(animateContent ? 1 : 0)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .opacity(animateContent ? 1 : 0)
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
            
            withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                offsetAnimation = true
            }
        }
    }
    
    @ViewBuilder
    func BookDetails() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button {
                    print("Reviews button tapped")
                } label: {
                    Label("Reviews", systemImage: "text.alignleft")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    print("Like button tapped")
                } label: {
                    Label("Like ", systemImage: "suit.heart")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    print("Shere button tapped")
                } label: {
                    Label("Shere", systemImage: "squere.and.arrow.up")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)

            }
            
            Divider()
                .padding(.top, 25)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    Text("About the book")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    //MARK: Dummy book detail
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 15)
                .padding(.top, 20)
            }
            Button {
                print("readNow button tapped")
            } label: {
                Text("Read now")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 45)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .fill(.blue.gradient)
                    }
                    .foregroundColor(.white)
            }
            .padding(.bottom, 15)

            
        }
        .padding(.top, 180)
        .padding([.horizontal, .top], 15)
        //MARK: Applyin offset animation
        .offset(y: offsetAnimation ?  0 : 100)
        .opacity(offsetAnimation ? 1 : 0)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
