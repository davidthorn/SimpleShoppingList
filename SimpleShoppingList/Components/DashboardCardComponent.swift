//
//  DashboardCardComponent.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct DashboardCardComponent: View {
    public let title: String
    public let icon: String
    public let rows: [(String, String)]

    public init(title: String, icon: String, rows: [(String, String)]) {
        self.title = title
        self.icon = icon
        self.rows = rows
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(AppStyle.accent)

            ForEach(rows, id: \.0) { row in
                HStack {
                    Text(row.0)
                        .foregroundStyle(AppStyle.textSecondary)
                    Spacer()
                    Text(row.1)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .cardSurface()
    }
}

#if DEBUG
#Preview {
    DashboardCardComponent(
        title: "Overview",
        icon: "chart.bar.fill",
        rows: [
            ("Total Lists", "2"),
            ("Total Items", "14"),
            ("Collected", "9")
        ]
    )
    .padding()
}
#endif
