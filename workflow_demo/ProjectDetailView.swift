//
//  ProjectDetailView.swift
//  workflow_demo
//
//  Created by Leandro Hernandez on 22/3/26.
//

import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: Hero Header
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: [project.colorHex.opacity(0.8), project.colorHex.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 200)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 56, height: 56)
                                Image(systemName: project.iconName)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                            StatusBadgeView(status: project.status)
                                .colorScheme(.dark)
                        }
                        Text(project.title)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        Text(project.category.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(20)
                }

                // MARK: Progress Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Overall Progress")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(Int(project.progress * 100))% Complete")
                                .font(.title3.bold())
                        }
                        Spacer()
                        CircularProgressView(progress: project.progress, color: project.colorHex)
                    }

                    ProgressView(value: project.progress)
                        .tint(project.colorHex)
                        .scaleEffect(x: 1, y: 1.5)
                }
                .padding(20)
                .background(.background)

                Divider()

                // MARK: Info Cards Row
                HStack(spacing: 0) {
                    InfoMetricView(icon: "person.2.fill", label: "Team", value: "\(project.teamSize) members")
                    Divider().frame(height: 50)
                    InfoMetricView(icon: "calendar", label: "Due Date", value: project.dueDate)
                    Divider().frame(height: 50)
                    InfoMetricView(icon: "tag.fill", label: "Category", value: project.category.rawValue)
                }
                .background(.background)

                Divider()

                // MARK: Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.headline)
                    Text(project.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .background(.background)

                Divider()

                // MARK: Segmented Tasks
                VStack(alignment: .leading, spacing: 16) {
                    Picker("View", selection: $selectedTab) {
                        Text("Tasks").tag(0)
                        Text("Team").tag(1)
                        Text("Files").tag(2)
                    }
                    .pickerStyle(.segmented)

                    if selectedTab == 0 {
                        TaskListSection(color: project.colorHex)
                    } else if selectedTab == 1 {
                        TeamSection()
                    } else {
                        FilesSection()
                    }
                }
                .padding(20)
                .background(.background)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(project.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Share action placeholder
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Circular Progress
struct CircularProgressView: View {
    let progress: Double
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 6)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            Text("\(Int(progress * 100))%")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(color)
        }
        .frame(width: 56, height: 56)
    }
}

// MARK: - Info Metric View
struct InfoMetricView: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.center)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }
}

// MARK: - Task List Section
struct TaskListSection: View {
    let color: Color

    let tasks: [(name: String, done: Bool, assignee: String)] = [
        ("Define wireframes", true, "Anna"),
        ("User interviews", true, "Carlos"),
        ("Prototype v1", true, "LH"),
        ("Visual design system", false, "Anna"),
        ("Dev handoff", false, "LH"),
        ("QA & Testing", false, "Carlos"),
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(tasks.indices, id: \.self) { index in
                let task = tasks[index]
                HStack(spacing: 12) {
                    Image(systemName: task.done ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(task.done ? color : .secondary)
                        .font(.system(size: 20))
                    Text(task.name)
                        .font(.subheadline)
                        .strikethrough(task.done, color: .secondary)
                        .foregroundStyle(task.done ? .secondary : .primary)
                    Spacer()
                    Text(task.assignee)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

// MARK: - Team Section
struct TeamSection: View {
    let members: [(name: String, role: String, initials: String, color: Color)] = [
        ("Anna López", "Designer", "AL", .purple),
        ("Carlos Ruiz", "Researcher", "CR", .green),
        ("Leandro H.", "Product Lead", "LH", .blue),
        ("María García", "Developer", "MG", .orange),
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(members.indices, id: \.self) { index in
                let member = members[index]
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(member.color.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Text(member.initials)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(member.color)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(member.name)
                            .font(.subheadline.weight(.medium))
                        Text(member.role)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

// MARK: - Files Section
struct FilesSection: View {
    let files: [(name: String, size: String, icon: String, color: Color)] = [
        ("Wireframes_v2.fig", "4.2 MB", "doc.fill", .purple),
        ("Research_report.pdf", "1.8 MB", "doc.text.fill", .red),
        ("Assets.zip", "12.5 MB", "archivebox.fill", .orange),
        ("Presentation.pptx", "3.1 MB", "play.rectangle.fill", .blue),
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(files.indices, id: \.self) { index in
                let file = files[index]
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(file.color.opacity(0.15))
                            .frame(width: 38, height: 38)
                        Image(systemName: file.icon)
                            .font(.system(size: 16))
                            .foregroundStyle(file.color)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(file.name)
                            .font(.subheadline.weight(.medium))
                        Text(file.size)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "arrow.down.circle")
                        .foregroundStyle(.blue)
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProjectDetailView(project: SampleData.projects[0])
    }
}
