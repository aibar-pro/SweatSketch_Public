//
//  HScrollModifier.swift
//  MyWorkoutPlanner
//
//  Created by aibaranchikov on 13/7/21.
//
//  Inspired by: https://levelup.gitconnected.com/snap-to-item-scrolling-debccdcbb22f

import SwiftUI


struct SnapCarouselModifier: ViewModifier {
    
    @State private var scrollOffset: CGFloat
    @State private var dragOffset: CGFloat

    @Binding var currentIndex: Int
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    var screenWidth: CGFloat
    
    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat, screenWidth: CGFloat, currentIndex: Binding<Int>) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        self.screenWidth = screenWidth
        self._currentIndex = currentIndex
        
        // Set Initial Offset to first Item
        let initialOffset = itemSpacing
        
        self._scrollOffset = State(initialValue: initialOffset)
        self._dragOffset = State(initialValue: 0)
        
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: items, perform: { [items] value in
                print("MODIFIER")
                if value == 0 {
                    scrollOffset = itemSpacing
                } else {
                    //Preserve scroll position after deletion of item
                    if items > value {
                        currentIndex = min(currentIndex, value-1)
                        currentIndex = max(currentIndex, 0)
                        //The scrollOffset is inverted
                        withAnimation {
                            scrollOffset = (CGFloat(currentIndex) * (itemWidth + itemSpacing) - itemSpacing) * -1
                        }
                    }
                }
            })
            .offset(x: scrollOffset + dragOffset, y: 0)
            .gesture(DragGesture()
                .onChanged({ event in
                    dragOffset = event.translation.width
                })
                .onEnded({ event in
                    // Scroll to where user dragged
                    scrollOffset += event.translation.width
                    dragOffset = 0
                    
                    // Calculate which item we are closest to using the defined size
                    // Have to invert scrollOffset due to leading frame alignment
                    var index = (-scrollOffset + itemSpacing + itemWidth/2) / (itemWidth + itemSpacing)
                    
                    // Should we stay at current index or are we closer to the next item...
                    if index.remainder(dividingBy: 1) > 0.5 {
                        index += 1
                    } else {
                        index = CGFloat(Int(index))
                    }
                    
                    // Protect from scrolling out of bounds
                    index = min(index, CGFloat(items) - 1)
                    index = max(index, 0)
                    
                    // Set final offset (snapping to item)
                    let newOffset = (index * itemWidth + index * itemSpacing) - itemSpacing
                    
                    currentIndex = Int(index)
                    
                    // Animate snapping
                    withAnimation {
                        scrollOffset = -newOffset
                    }
                    
                })
            )
    }
}
