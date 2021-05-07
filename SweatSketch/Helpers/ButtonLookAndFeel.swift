//
//  ButtonLookAndFeel.swift
//  BeerMenu
//
//  Created by aibaranchikov on 7/4/21.
//

import SwiftUI

struct NeuButtonStyle: ButtonStyle {
    let opacity: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(60)
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 10)
//                        Circle()
                            .fill(Color.white.opacity(opacity))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: -5, y: -5)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: 10, y: 10)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
//                        Circle()
                            .fill(Color.white.opacity(opacity))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
    }
}


struct Neumorphic: ViewModifier {
    
    var bgColor: Color
    
    @Binding var isPressed: Bool

    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .dropShadow, radius: self.isPressed ? 7: 10, x: self.isPressed ? 5: 10, y: self.isPressed ? 5: 10)
                        .shadow(color: .dropLight, radius: self.isPressed ? 7: 10, x: self.isPressed ? -5: -10, y: self.isPressed ? -5: -10)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(bgColor)
                }
            )
            .scaleEffect(self.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
            .animation(.spring())
    }
}

extension View {
    func neumorphic(isPressed: Binding<Bool>, bgColor: Color) -> some View {
        self.modifier(Neumorphic(bgColor: bgColor, isPressed: isPressed))
    }
}

struct HaloEffect: ViewModifier {
    var paddingAdjustment : CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(40 + self.paddingAdjustment)
            .foregroundColor(Color(UIColor.systemGray))
            .background(
                ZStack {
                    Circle()
                        .stroke(Color.haloStroke, lineWidth: 7)
                        .opacity(0.8)
                        .shadow(color: .haloShadow, radius: 15)
                    }
            )
    }
}

extension View {
    func haloEffect(_ paddingAdjustment: CGFloat? = 0) -> some View {
        self.modifier(HaloEffect(paddingAdjustment: paddingAdjustment ?? 0))
    }
}

struct InnerShadow: ViewModifier {
    var paddingAdjustment : CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(40 + self.paddingAdjustment)
            .foregroundColor(Color(UIColor.systemGray))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.innerShadowStroke, lineWidth: 4)
                    .shadow(color: .innerShadowShadow, radius: 3, x: 5, y: 5)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                    .shadow(color: .dropLight, radius: 2, x: -2, y: -2)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                )
 
    }
}

extension View {
    func innerShadow(_ paddingAdjustment: CGFloat? = 0) -> some View {
        self.modifier(InnerShadow(paddingAdjustment: paddingAdjustment ?? 0))
    }
}

struct ButtonLookAndFeel: View {
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        
        VStack {
            Text(isPressed ? "Bye!" : "Hello World!")
                .padding(.bottom)
            
            HStack {
                Button(action: {
                    self.isPressed.toggle()
                }) {
                    ZStack {
                        Text("Button 1")
                            .haloEffect()
                    }
                }
                
                Button(action: {
                    self.isPressed.toggle()
                }) {
                    ZStack {
                        Text("Button 2")
                            .innerShadow()
                    }
               }
            }
            .padding(.bottom)
            
            Button(action: {
                self.isPressed.toggle()
            }) {
                ZStack {
                    
                    Text("Button 3")
                        .foregroundColor(Color(UIColor.systemGray))
                        .neumorphic(isPressed: $isPressed, bgColor: .neuBackground)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color.neuBackground)
        .ignoresSafeArea(.all)
    }
}

struct ButtonLookAndFeel_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLookAndFeel()
    }
}
