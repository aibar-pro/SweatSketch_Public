//
//  FormField.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUI

struct FormFieldLayout {
    var cornerRadius: CGFloat = Constants.Design.cornerRadius
    var horizontalInset: CGFloat = Constants.Design.cornerRadius
    var verticalInset:   CGFloat = Constants.Design.cornerRadius
    var captionTrailing: CGFloat = Constants.Design.cornerRadius / 4
    var borderWidth:     CGFloat = 1

    static let compact = FormFieldLayout(
        horizontalInset: Constants.Design.cornerRadius / 2,
        verticalInset:   Constants.Design.cornerRadius / 2
    )
}

struct FormField<Content: View>: View {
    var title: LocalizedStringKey
    var contentMaxWidth: CGFloat?
    var layout: FormFieldLayout = .init()
    let content: () -> Content
    
    @State private var captionSize: CGSize = .zero
    @State private var inputSize: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            content()
                .frame(
                    minWidth: captionSize.width + layout.cornerRadius,
                    maxWidth: contentMaxWidth,
                    alignment: .trailing
                )
                .measure($inputSize)
                .padding(.vertical, layout.verticalInset)
                .padding(.horizontal, layout.horizontalInset)
                .background(
                    CaptionBorderShape(
                        captionWidth: captionSize.width,
                        cornerRadius: layout.cornerRadius
                    )
                    .stroke(
                        Constants.Design.Colors.elementFgPrimary,
                        lineWidth: layout.borderWidth
                    )
                )
            
            Text(title)
                .font(.caption)
                .padding(.trailing, layout.captionTrailing)
                .measure($captionSize)
                .padding(.leading, layout.cornerRadius)
                .adaptiveForegroundStyle(Constants.Design.Colors.elementFgMediumEmphasis)
                .offset(y: -captionLift)
        }
        .padding(.top, captionLift)
    }
    
    private var captionLift: CGFloat {
        captionSize.height * 0.67
    }
}

#Preview {
    VStack(spacing: 50) {
        FormField(title: "user.profile.username") {
            TextField("", text: .constant("Preview"))
        }
        
        FormField(title: "user.profile.age", layout: .compact) {
            Picker("", selection: .constant(2)) {
                ForEach(0..<11) {
                    Text(String($0)).tag($0)
                }
            }
        }
        
        FormField(
            title: "user.profile.age",
            contentMaxWidth: 200
        ) {
            IntegerTextField(value: .constant(5))
        }
    }
}

struct CaptionBorderShape: Shape {
    var captionWidth: CGFloat

    var cornerRadius: CGFloat = 12

    var captionInset: CGFloat = 0

    var animatableData: CGFloat {
        get { captionWidth }
        set { captionWidth = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let r = min(cornerRadius, min(rect.width, rect.height) / 2)

        let gapStart = r + captionInset
        let gapEnd   = min(rect.width - r, gapStart + captionWidth + captionInset)

        var p = Path()

        p.move(to: CGPoint(x: gapEnd, y: 0))

        p.addLine(to: CGPoint(x: rect.maxX - r, y: 0))
        p.addArc(
            center: CGPoint(x: rect.maxX - r, y: r),
            radius: r,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )

        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))

        p.addArc(
            center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
            radius: r,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        p.addLine(to: CGPoint(x: r, y: rect.maxY))

        p.addArc(
            center: CGPoint(x: r, y: rect.maxY - r),
            radius: r,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        p.addLine(to: CGPoint(x: 0, y: r))

        p.addArc(
            center: CGPoint(x: r, y: r),
            radius: r,
            startAngle: .degrees(180),
            endAngle: .degrees(255),
            clockwise: false
        )

//        p.addLine(to: CGPoint(x: gapStart, y: 0))

        return p
    }
}
