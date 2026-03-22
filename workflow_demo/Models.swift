//
//  Models.swift
//  workflow_demo
//
//  Created by Leandro Hernandez on 22/3/26.
//

import SwiftUI

// MARK: - Project Model
struct Project: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: ProjectCategory
    let status: ProjectStatus
    let progress: Double
    let teamSize: Int
    let dueDate: String
    let iconName: String
    let colorHex: Color
}

enum ProjectCategory: String, CaseIterable {
    case design = "Design"
    case development = "Development"
    case marketing = "Marketing"
    case research = "Research"

    var iconName: String {
        switch self {
        case .design: return "paintbrush.fill"
        case .development: return "chevron.left.forwardslash.chevron.right"
        case .marketing: return "megaphone.fill"
        case .research: return "magnifyingglass"
        }
    }
}

enum ProjectStatus: String {
    case active = "Active"
    case inReview = "In Review"
    case completed = "Completed"
    case onHold = "On Hold"

    var color: Color {
        switch self {
        case .active: return .green
        case .inReview: return .orange
        case .completed: return .blue
        case .onHold: return .gray
        }
    }
}

// MARK: - User Model
struct UserProfile {
    let name: String
    let role: String
    let email: String
    let avatarInitials: String
    let joinDate: String
    let projectsCompleted: Int
    let tasksCompleted: Int
    let hoursLogged: Int
}

// MARK: - Stat Card Model
struct StatCard: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let iconName: String
    let color: Color
    let trend: String
}

// MARK: - Sample Data
struct SampleData {
    static let projects: [Project] = [
        Project(title: "App Redesign", description: "Complete overhaul of the mobile application UI/UX with modern design patterns and improved user flows.", category: .design, status: .active, progress: 0.72, teamSize: 4, dueDate: "Apr 15, 2026", iconName: "paintbrush.fill", colorHex: .purple),
        Project(title: "API Integration", description: "Connect backend services with the new REST API endpoints and implement proper error handling.", category: .development, status: .inReview, progress: 0.90, teamSize: 3, dueDate: "Mar 30, 2026", iconName: "chevron.left.forwardslash.chevron.right", colorHex: .blue),
        Project(title: "Q2 Campaign", description: "Launch the second quarter digital marketing campaign targeting new user segments.", category: .marketing, status: .active, progress: 0.45, teamSize: 5, dueDate: "May 1, 2026", iconName: "megaphone.fill", colorHex: .orange),
        Project(title: "User Research", description: "Conduct in-depth interviews and usability tests to gather insights for the next product iteration.", category: .research, status: .completed, progress: 1.0, teamSize: 2, dueDate: "Mar 10, 2026", iconName: "magnifyingglass", colorHex: .green),
        Project(title: "Dashboard v2", description: "Rebuild the analytics dashboard with real-time data visualization and customizable widgets.", category: .development, status: .active, progress: 0.30, teamSize: 6, dueDate: "Jun 1, 2026", iconName: "chart.bar.xaxis", colorHex: .teal),
        Project(title: "Brand Identity", description: "Refresh the brand guidelines including new logo variations, color palette and typography.", category: .design, status: .onHold, progress: 0.15, teamSize: 2, dueDate: "TBD", iconName: "star.fill", colorHex: .pink),
    ]

    static let user = UserProfile(
        name: "Leandro Hernandez",
        role: "Product Designer",
        email: "leandro.hernandez@demo.com",
        avatarInitials: "LH",
        joinDate: "January 2024",
        projectsCompleted: 24,
        tasksCompleted: 189,
        hoursLogged: 1_240
    )

    static let stats: [StatCard] = [
        StatCard(title: "Active Projects", value: "8", iconName: "folder.fill", color: .blue, trend: "+2 this month"),
        StatCard(title: "Tasks Done", value: "43", iconName: "checkmark.circle.fill", color: .green, trend: "+12 this week"),
        StatCard(title: "Hours Logged", value: "126", iconName: "clock.fill", color: .orange, trend: "This month"),
        StatCard(title: "Team Members", value: "12", iconName: "person.3.fill", color: .purple, trend: "Across 4 teams"),
    ]
}
