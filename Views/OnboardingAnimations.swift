//
//  OnboardingAnimations.swift
//  How To
//
//  Custom animations and view modifiers for onboarding
//

import SwiftUI

// MARK: - Custom View Modifiers

struct OnboardingAppearance: ViewModifier {
    let delay: Double
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 30)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

extension View {
    func onboardingAppearance(delay: Double = 0) -> some View {
        modifier(OnboardingAppearance(delay: delay))
    }
}

// MARK: - Pulse Animation

struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

extension View {
    func pulseEffect() -> some View {
        modifier(PulseEffect())
    }
}

// MARK: - Shimmer Effect

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 500
                }
            }
    }
}

extension View {
    func shimmerEffect() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Bounce Animation

struct BounceEffect: ViewModifier {
    @State private var isBouncing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isBouncing ? 1.0 : 0.9)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isBouncing = true
                }
            }
    }
}

extension View {
    func bounceEffect() -> some View {
        modifier(BounceEffect())
    }
}

// MARK: - Slide In Animation

struct SlideInEffect: ViewModifier {
    let direction: Edge
    let delay: Double
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .offset(
                x: direction == .leading ? (isVisible ? 0 : -100) : (direction == .trailing ? (isVisible ? 0 : 100) : 0),
                y: direction == .top ? (isVisible ? 0 : -100) : (direction == .bottom ? (isVisible ? 0 : 100) : 0)
            )
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

extension View {
    func slideIn(from direction: Edge, delay: Double = 0) -> some View {
        modifier(SlideInEffect(direction: direction, delay: delay))
    }
}

// MARK: - Typewriter Effect

struct TypewriterEffect: ViewModifier {
    let text: String
    @State private var displayedText = ""
    @State private var currentIndex = 0
    
    func body(content: Content) -> some View {
        Text(displayedText)
            .onAppear {
                startTypewriter()
            }
    }
    
    private func startTypewriter() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText += String(text[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

extension View {
    func typewriterEffect(text: String) -> some View {
        modifier(TypewriterEffect(text: text))
    }
}

// MARK: - Gradient Animation

struct AnimatedGradient: ViewModifier {
    let colors: [Color]
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .init(x: phase, y: 0),
                    endPoint: .init(x: phase + 1, y: 1)
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func animatedGradient(colors: [Color]) -> some View {
        modifier(AnimatedGradient(colors: colors))
    }
}

// MARK: - Rotation Animation

struct RotationEffect: ViewModifier {
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

extension View {
    func rotationEffect() -> some View {
        modifier(RotationEffect())
    }
}

// MARK: - Scale Animation

struct ScaleEffect: ViewModifier {
    let from: CGFloat
    let to: CGFloat
    let duration: Double
    @State private var scale: CGFloat
    
    init(from: CGFloat = 0.8, to: CGFloat = 1.0, duration: Double = 0.6) {
        self.from = from
        self.to = to
        self.duration = duration
        self._scale = State(initialValue: from)
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: duration, dampingFraction: 0.7)) {
                    scale = to
                }
            }
    }
}

extension View {
    func scaleEffect(from: CGFloat = 0.8, to: CGFloat = 1.0, duration: Double = 0.6) -> some View {
        modifier(ScaleEffect(from: from, to: to, duration: duration))
    }
}

