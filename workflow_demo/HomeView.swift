//
//  HomeView.swift
//  workflow_demo
//
//  Created by Leandro Hernandez on 22/3/26.
//

import SwiftUI

struct HomeView: View {
    let stats = SampleData.stats
    let projects = SampleData.projects
    @State private var greetingHour: Int = Calendar.current.component(.hour, from: Date())

    private var greeting: String {
        switch greetingHour {
        case 6..<12: return "Good Morning"
        case 12..<18: return "Good Afternoon"
        default: return "Good Evening"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Header
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(greeting + ",")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(SampleData.user.name.components(separatedBy: " ").first ?? "")
                                .font(.title.bold())
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 44, height: 44)
                            Text(SampleData.user.avatarInitials)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // MARK: Stats Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Overview")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(stats) { stat in
                                StatCardView(stat: stat)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: Recent Projects
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Projects")
                                .font(.headline)
                            Spacer()
                            Text("See all")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                        .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(projects.prefix(3)) { project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    ProjectRowView(project: project)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: Activity Banner
                    ActivityBannerView()
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Stat Card View
struct StatCardView: View {
    let stat: StatCard

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: stat.iconName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(stat.color)
                    .frame(width: 30, height: 30)
                    .background(stat.color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Spacer()
            }
            Text(stat.value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(stat.trend)
                .font(.caption2)
                .foregroundStyle(stat.color)
        }
        .padding(14)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Project Row View
struct ProjectRowView: View {
    let project: Project

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(project.colorHex.opacity(0.15))
                    .frame(width: 46, height: 46)
                Image(systemName: project.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(project.colorHex)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(project.title)
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    StatusBadgeView(status: project.status)
                }
                Text(project.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ProgressView(value: project.progress)
                    .tint(project.colorHex)
            }
        }
        .padding(14)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Status Badge
struct StatusBadgeView: View {
    let status: ProjectStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(status.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(status.color.opacity(0.15))
            .clipShape(Capsule())
    }
}

// MARK: - Activity Banner
struct ActivityBannerView: View {
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 44, height: 44)
                Image(systemName: "flame.fill")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("You're on a streak! 🎉")
                    .font(.subheadline.weight(.semibold))
                Text("7 consecutive days of activity. Keep it up!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(
            LinearGradient(colors: [.orange.opacity(0.1), .yellow.opacity(0.05)], startPoint: .leading, endPoint: .trailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.orange.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    HomeView()
}
