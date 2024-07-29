//
//  HorizontalPagingScrollView.swift
//  BlogDemos
//
//  Created by Jenya Lebid on 7/28/24.
//

import SwiftUI

struct Card: Identifiable, Hashable {
    var id: UUID = UUID()
    var text: String
}

struct HorizontalPagingScrollView: View {
    
    @State private var cards: [Card] = [Card(text: "Card 1"), Card(text: "Card 2")]
    
    @State private var activeCardIndex: Int? = 0
    @State private var activeCard: Card?
    
    @State private var isHorizontal = false

    var body: some View {
        NavigationStack {
            TabView {
                addRemoveCards
                    .tabItem {
                        Text("1")
                    }
                    .toolbar {
                        Button(isHorizontal ? "Vertical" : "Horizontal") {
                            withAnimation {
                                isHorizontal.toggle()
                            }
                        }
                    }
                simpleCards
                    .tabItem {
                        Text("2")
                    }
                indexBased
                    .tabItem {
                        Text("3")
                    }
            }
        }
    }
    
    func cardView(for card: Card) -> some View {
        Text(card.text)
            .frame(maxWidth: .infinity, maxHeight: isHorizontal ? .infinity : 200)
            .background(.background)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
    }
}

extension HorizontalPagingScrollView { // MARK: Simple cards.
    
    @ViewBuilder
    var simpleCards: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(cards, id: \.self) { card in
                        cardView(for: card)
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeCard)
            .scrollIndicators(.never)
            simplePagingControl
            Spacer()
        }
        .onAppear {
            activeCard = cards.first
        }
    }
    
    var simplePagingControl: some View {
        HStack {
            ForEach(cards) { card in
                Button {
                    withAnimation {
                        activeCard = card
                    }
                } label: {
                    Image(systemName: activeCard == card ? "circle.fill" : "circle")
                        .foregroundStyle(Color(uiColor: .systemGray3))
                }
            }
        }
    }
}

extension HorizontalPagingScrollView { // MARK: Cards adding and removing.
    
    @ViewBuilder
    var addRemoveCards: some View {
        if isHorizontal {
            horizontalCards
        }
        else {
            vertCards
        }
    }
    
    @ViewBuilder
    var vertCards: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    cardsStack
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .trailing)))
                }
                
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeCardIndex)
            .scrollIndicators(.never)
            pagingControl
            Spacer()
        }
    }
    
    @ViewBuilder
    var horizontalCards: some View {
        HStack {
            ScrollView {
                VStack {
                    cardsStack
                        .containerRelativeFrame(.vertical, count: 1, spacing: 0)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                }
                
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeCardIndex)
            .scrollIndicators(.never)
            pagingControl
        }
    }
    
    @ViewBuilder
    var pagingControl: some View {
        if isHorizontal {
            VStack {
                pageControlButtons
            }
        }
        else {
            HStack {
                pageControlButtons
            }
        }
    }
    
    var pageControlButtons: some View {
        ForEach(0..<cards.count + 1, id: \.self) { value in
            let regularImage = value == cards.count ? "plus.circle" : "circle"
            let selectedImage = value == cards.count ? "plus.circle.fill" : "circle.fill"
            
            Button {
                withAnimation {
                    activeCardIndex = value
                }
            } label: {
                Image(systemName: activeCardIndex == value ? selectedImage : regularImage)
                    .foregroundStyle(Color(uiColor: .systemGray3))
            }
        }
    }
    
    @ViewBuilder
    var cardsStack: some View {
        ForEach(0..<cards.count, id: \.self) { index in
            cardView(for: cards[index])
        }
        newCard
            .id(cards.count)
    }
    
    var newCard: some View {
        Button {
            withAnimation {
                cards.append(Card(text: "New Card \(cards.count + 1)"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    withAnimation {
                        activeCardIndex = cards.count
                    }
                })
            }
        } label: {
            VStack {
                Image(systemName: "plus")
                Text("New Card")
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            .background(.background)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
        }
    }
}

extension HorizontalPagingScrollView { //MARK: Index based elements.
    
    @ViewBuilder
    var indexBased: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    Group {
                        Circle()
                            .fill(.red)
                            .id(0)
                        Rectangle()
                            .fill(.blue)
                            .id(1)
                        Capsule()
                            .fill(.orange)
                            .id(2)
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .id(3)
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeCardIndex)
            .scrollIndicators(.never)
            .frame(height: 200)
            indexBasedPaging
            Spacer()
        }
    }
    
    var indexBasedPaging: some View {
        HStack {
            ForEach(0..<4) { index in
                Button {
                    withAnimation {
                        activeCardIndex = index
                    }
                } label: {
                    Image(systemName: activeCardIndex == index ? "circle.fill" : "circle")
                        .foregroundStyle(Color(uiColor: .systemGray3))
                }
            }
        }
    }
}

#Preview {
    HorizontalPagingScrollView()
}
