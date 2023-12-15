//
//  SensitiveImageOverlay.swift
//  NukeSensitivity
//
//  Created by Sam Spencer on 12/11/23.
//  Copyright © 2023 nenos, Inc. All rights reserved.
//

import NukeUI
import SensitiveContentAnalysis
import SwiftUI

public struct SensitiveImageOverlay<Content: View, S: Shape, MenuButtons: View>: View {
    
    @ObservedObject public var viewModel: SensitiveContentShim
    public var overlayTitle: LocalizedStringKey = "This image may be sensitive."
    
    public var content: Content
    public var clipShape: S
    public var actionButtons: MenuButtons?
    
    public init(
        viewModel: SensitiveContentShim,
        overlayTitle: LocalizedStringKey = "This image may be sensitive.",
        clipShape: S,
        @ViewBuilder content: () -> Content,
        actionButtons: (() -> MenuButtons)? = nil
    ) {
        self.viewModel = viewModel
        self.overlayTitle = overlayTitle
        self.content = content()
        self.clipShape = clipShape
        self.actionButtons = actionButtons?()
    }
    
    public var body: some View {
        if viewModel.policy == .disabled || viewModel.isSensitive == false {
            content
        } else {
            obfuscatedContent
        }
    }
    
    private var obfuscatedContent: some View {
        content
            .overlay {
                obfuscationOverlay
            }
            .overlay(alignment: .bottomTrailing) {
                showButton
            }
            .overlay(alignment: .topTrailing) {
                helpMenu
            }
            .accessibilityLabel(Text(overlayTitle))
    }
    
    @ViewBuilder private var obfuscationOverlay: some View {
        if viewModel.showSensitiveContent == false {
            Text(overlayTitle)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Material.ultraThick, in: Rectangle())
                .clipShape(clipShape)
        } else {
            EmptyView()
        }
    }
    
    private var showButton: some View {
        Button {
            toggleShow()
        } label: {
            Label(
                viewModel.showSensitiveContent ? "Hide" : "Show",
                systemImage: viewModel.showSensitiveContent ? "eye.slash.fill" : "eye.fill"
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Material.bar, in: Capsule())
        }
        .foregroundStyle(.secondary)
        .padding([.trailing, .bottom])
    }
    
    @ViewBuilder private var helpMenu: some View {
        if let actionButtons {
            Menu {
                actionButtons
            } label: {
                Image(systemName: "exclamationmark.triangle.fill")
                    .padding(6)
                    .background(Material.bar, in: Circle())
            }
            .foregroundStyle(.secondary)
            .padding([.trailing, .top])
        } else {
            EmptyView()
        }
    }
    
    private func toggleShow() {
        if viewModel.showSensitiveContent == true {
            viewModel.hideContent()
        } else {
            if viewModel.policy == .descriptiveInterventions {
                viewModel.requireIntervention()
            } else {
                viewModel.proceedToShowContent()
            }
        }
    }
    
}

public extension SensitiveImageOverlay where MenuButtons == EmptyView {
    
    init(
        viewModel: SensitiveContentShim,
        overlayTitle: LocalizedStringKey = "This image may be sensitive.",
        clipShape: S,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.overlayTitle = overlayTitle
        self.content = content()
        self.clipShape = clipShape
        self.actionButtons = nil
    }
    
}

#Preview {
    let nonSensitiveURL = URL(string: "https://unsplash.com/photos/ByU4TX_lSIQ/download?ixid=M3wxMjA3fDB8MXxhbGx8MjN8fHx8fHwyfHwxNzAyMzIyNDUzfA&force=true&w=1920")
    
    return LazyImage(url: nonSensitiveURL)
        .aspectRatio(1.25, contentMode: .fit)
        .frame(width: 360, height: 270)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .sensitiveOverlay(
            viewModel: SensitiveContentShim(),
            clipShape: RoundedRectangle(cornerRadius: 12)
        )
}
