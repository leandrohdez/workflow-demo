//
//  ExploreView.swift
//  workflow_demo
//
//  Created by Leandro Hernandez on 22/3/26.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedCategory: ProjectCategory? = nil
    @State private var selectedStatus: ProjectStatus? = nil

    let projects = SampleData.projects

    var filteredProjects: [Project] {
        projects.filter { project in
            let matchesSearch = searchText.isEmpty ||
                project.title.localizedCaseInsensitiveContains(searchText) ||
                project.description.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || project.category == selectedCategory
            let matchesStatus = selectedStatus == nil || project.status == selectedStatus
            return matchesSearch && matchesCategory && matchesStatus
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: Search Bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search projects...", text: $searchText)
                        .font(.subheadline)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.vertical, 12)

                // MARK: Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(label: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(ProjectCategory.allCases, id: \.self) { category in
                            FilterChip(
                                label: category.rawValue,
                                iconName: category.iconName,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = selectedCategory == category ? nil : category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 12)

                // MARK: Results Count
                HStack {
                    Text("\(filteredProjects.count) project\(filteredProjects.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                // MARK: Project List
                if filteredProjects.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredProjects) { project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    ExploreProjectCard(project: project)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let label: String
    var iconName: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = iconName {
                    Image(systemName: icon)
                        .font(.caption.weight(.semibold))
                }
                Text(label)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.secondarySystemGroupedBackground))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}

// MARK: - Explore Project Card
struct ExploreProjectCard: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(project.colorHex.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: project.iconName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(project.colorHex)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.title)
                        .font(.headline)
                    HStack(spacing: 6) {
                        Image(systemName: project.category.iconName)
                            .font(.caption2)
                        Text(project.category.rawValue)
                            .font(.caption)
                        Text("·")
                            .font(.caption)
                        Image(systemName: "person.2.fill")
                            .font(.caption2)
                        Text("\(project.teamSize)")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
                Spacer()
                StatusBadgeView(status: project.status)
            }

            Text(project.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Progress")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(Int(project.progress * 100))%")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(project.colorHex)
                    }
                    ProgressView(value: project.progress)
                        .tint(project.colorHex)
                }
            }

            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Due \(project.dueDate)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Empty State
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("No projects found")
                .font(.headline)
            Text("Try adjusting your search or filters")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ExploreView()
}
