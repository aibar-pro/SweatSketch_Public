//
//  BottomSheetView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 25.06.2025.
//

import SwiftUI

enum BottomSheetType {
    case singleTextField(
        kind: SingleFieldFormKind,
        initialText: String = "",
        action: (String) -> Void,
        cancel: () -> Void
    )
    case timePicker(
        kind: TimePickerFormKind,
        initialValue: Int,
        action: (Int) -> Void,
        secondaryAction: (() -> Void)? = nil,
        cancel: () -> Void
    )
    case actionEditor(
        for: ActionDraftModel,
        action: (ActionDraftModel) -> Void,
        cancel: () -> Void
    )
    
    @ViewBuilder
    func view(onDismiss: (() -> Void)? = nil) -> some View {
        Group {
            switch self {
            case .singleTextField(let kind, let text, let action, let cancel):
                SingleFieldFormSheet(
                    kind: kind,
                    initialText: text,
                    onSubmit: { newName in
                        action(newName)
                        onDismiss?()
                    },
                    onCancel: {
                        cancel()
                        onDismiss?()
                    }
                )
            case .timePicker(let kind, let initialValue, let action, let secondaryAction, let cancel):
                TimePickerFormSheet(
                    kind: kind,
                    initialDuration: initialValue,
                    onSubmit: { value in
                        action(value)
                        onDismiss?()
                    },
                    onCancel: {
                        cancel()
                        onDismiss?()
                    },
                    additionalContent: {
                        if kind == .workout {
                            RectangleButton(
                                content: {
                                    HStack(alignment: .lastTextBaseline, spacing: Constants.Design.spacing / 2) {
                                        Text("workout.edit.advanced.rest.settings.link")
                                        Image(systemName: "arrow.up.right")
                                    }
                                },
                                style: .inlineLink,
                                action: {
                                    onDismiss?()
                                    secondaryAction?()
                                }
                            )
                        }
                    }
                )
            case .actionEditor(let draft, let action, let cancel):
                ActionEditorView(
                    draft: draft,
                    onSubmit: { value in
                        action(value)
                        onDismiss?()
                    },
                    onCancel: {
                        cancel()
                        onDismiss?()
                    }
                )
            }
        }
    }
    
    var cancelAction: (() -> Void)? {
        switch self {
        case .singleTextField(_, _, _, let cancel):
            return cancel
        case .timePicker(_, _, _, _, let cancel):
            return cancel
        case .actionEditor(_, _, let cancel):
            return cancel
        }
    }
}

struct BottomSheetView<Content: View>: View {
    let dragThreshold: CGFloat = 100
    
    @State private var opacity: CGFloat = 0
    @State private var offset = CGSize.zero
    @State private var showContent: Bool = false
    
    let onDismiss: (() -> Void)?
    var content: () -> Content
    
    let targetBgOpacity: CGFloat = 0.1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .opacity(opacity)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            if showContent {
                mainContent
                    .offset(x: 0, y: offset.height)
            }
        }
        .onAppear {
            animateAppearance()
        }
    }
    
    private var mainContent: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Constants.Design.Colors.elementFgPrimary)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .center)
                .contentShape(Rectangle())
                .gesture(drag)
            
            content()
            
            Rectangle()
                .fill(.clear)
                .frame(height: dragThreshold * 2)
                .ignoresSafeArea()
        }
        .padding(.horizontal, Constants.Design.spacing)
        .materialBackground(
            shape: TopCornerRoundedShape(cornerRadius: Constants.Design.cornerRadius)
        )
        .lightShadow(paddingEdges: .vertical)
        .offset(CGSize(width: 0, height: dragThreshold * 2))
        .transition(.move(edge: .bottom))
    }
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = offset
                newLocation.height += value.translation.height
                
                if newLocation.height < -dragThreshold {
                    self.offset = offset
                } else {
                    self.offset = newLocation
                }
            }
            .onEnded { _ in
                if offset.height > dragThreshold {
                    dismiss()
                } else {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        offset = .zero
                    }
                }
            }
    }
    
    private func animateAppearance() {
        let bgAnimationDuration: Double = 0.25
        let bgAnimationDelay: Double = 0.1
        
        withAnimation(
            .easeIn(duration: bgAnimationDuration)
            .delay(bgAnimationDelay)
        ) {
            opacity = targetBgOpacity
        }
        withAnimation(
            .easeOut(duration: bgAnimationDuration)
            .delay(bgAnimationDuration + bgAnimationDelay / 2)
        ) {
            showContent = true
        }
    }
    
    private func animateDismissal() {
        let contentAnimationDuration: Double = 0.25
        let contentAnimationDelay: Double = 0.1
        
        withAnimation(
            .easeIn(duration: contentAnimationDuration)
            .delay(contentAnimationDelay)
        ) {
            showContent = false
        }
        withAnimation(
            .easeOut(duration: contentAnimationDuration)
            .delay(contentAnimationDuration + contentAnimationDelay / 2)
        ) {
            opacity = 0
        }
    }
    
    private func dismiss() {
        animateDismissal()
        onDismiss?()
    }
}

#Preview {
    BottomSheetView(
        onDismiss: {},
        content: {
            Slider(
                value: .constant(0.3),
                in: 0...1,
                onEditingChanged: { _ in }
            )
        }
    )
}
