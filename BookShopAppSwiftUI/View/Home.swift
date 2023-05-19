//
//  Home.swift
//  BookShopAppSwiftUI
//
//  Created by Helen Poe on 07.03.2023.
//

import SwiftUI
var tags: [String] = ["All", "Adventure", "Biography", "Classical", "Fairy tales", "Fantasy", "History"]

struct Home: View {
    @State private var activeTag: String = "All"
    @State private var caruselMode: Bool = false
    //MARK: Matched Geometry Effects
    @Namespace private var animation
    //MARK: Detail View Properties
    @State private var showDetailView: Bool = false
    @State private var selectedBook: Book?
    @State private var animateCurentBook: Bool = false
    
    var body: some View {
        VStack(spacing: 15){
            HStack{
                Text("Browse")
                    .font(.largeTitle.bold())
                
                Text("Recommended")
                    .fontWeight(.semibold)
                    .padding(.leading, 15)
                    .foregroundColor(.gray)
                    .offset(y: 2 )
                
                Spacer(minLength: 10)
                
                Menu {
                    Button("Toggle Carousel Mode (\(caruselMode ? "On" : "Off"))"){
                           caruselMode.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal,15)
            
            TagsView()
            
            GeometryReader {
                let size = $0.size
                
                ScrollView(.vertical, showsIndicators: false) {
                    //MARK: Books card View
                    VStack(spacing: 35) {
                        ForEach(samplBooks) { book in
                            BookCardView(book)
                                //MARK: Opening DetailView , when ever card is tapped
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        animateCurentBook = true
                                        selectedBook = book
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        withAnimation {
                                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                                                showDetailView = true
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .padding(.bottom, bottomPadding(size))
                    .background {
                        ScrollViewDetector(carouselMode: $caruselMode, totalCardCount: samplBooks.count)
                    }
                }
                //MARK: Since we need offset frome here and not from global View
                .coordinateSpace(name: "SCROOLVIEW")
            }
            .padding(.top, 15)
        }
        .overlay {
            if let selectedBook, showDetailView {
                DetailView(show: $showDetailView, animation: animation, book: selectedBook)
                //MARK: For more fluent animation transition
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        }
        .onChange(of: showDetailView) { newValue in
            if !newValue {
                //MARK: Restting book animation
                withAnimation(.easeInOut(duration: 0.15).delay(0.4)) {
                    animateCurentBook = false
                }
            }
        }
    }
    
    //MARK: Bottom padding for the last card to move up to the top
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat {
        let cardHeight: CGFloat = 220
        let scrollViewHeight: CGFloat = size.height
        
        return scrollViewHeight - cardHeight - 40
    }
    
    //MARK: Book Card View
    @ViewBuilder
    func BookCardView(_ book: Book) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROOLVIEW"))
            
            HStack(spacing: -25) {
                //MARK: Book detail card
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("By \(book.autor)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    //MARK: Rating View
                    RatingView(rating: book.rating)
                        .padding(.top, 10)
                    
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 4) {
                        Text("\(book.bookViews)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("Views")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)
                //MARK: Moving the book, it it's tapped
                .offset(x: animateCurentBook && selectedBook?.id == book.id ? -20 : 0)
                
                //MARK: Book cower image
                ZStack{
                    if !(showDetailView && selectedBook?.id == book.id) {
                        Image(book.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            //MARK: Mathed Geometry ID
                            .matchedGeometryEffect(id: book.id, in: animation)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(degrees: ConvertOffSetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
        }
        .frame(height: 220)
    }
    
    //MARK: Converting MinY to rotation
    func ConvertOffSetToRotation(_ rect: CGRect)-> CGFloat {
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constreinedProgress = min(-progress, 1.0)
        
        return constreinedProgress * 90
    }
    
    //MARK: Tags View
    @ViewBuilder
    func TagsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background {
                            if activeTag == tag {
                                Capsule()
                                    .fill(.blue)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            } else {
                                Capsule()
                                    .fill(.gray.opacity(0.2))
                            }
                        }
                        .foregroundColor(activeTag == tag ?  .white : .gray)
                    //MARK: Changing active tag when tapped one of the tag
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activeTag = tag
                            }
                        }
                }
            }
            .padding(.horizontal, 15)
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



