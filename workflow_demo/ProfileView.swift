//
//  ProfileView.swift
//  workflow_demo
//
//  Created by Leandro Hernandez on 22/3/26.
//

import SwiftUI

struct ProfileView: View {
    let user = SampleData.user
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var analyticsEnabled = true
    @State private var showingEditAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Profile Header
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 90, height: 90)
                                Text(user.avatarInitials)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            Button(action: { showingEditAlert = true }) {
                                ZStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 26, height: 26)
                                    Image(systemName: "pencil")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                        }

                        VStack(spacing: 4) {
                            Text(user.name)
                                .font(.title3.bold())
                            Text(user.role)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(user.email)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Member since \(user.joinDate)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 24)

                    // MARK: Stats Row
                    HStack(spacing: 0) {
                        ProfileStatView(value: "\(user.projectsCompleted)", label: "Projects")
                        Divider().frame(height: 40)
                        ProfileStatView(value: "\(user.tasksCompleted)", label: "Tasks")
                        Divider().frame(height: 40)
                        ProfileStatView(value: "\(user.hoursLogged)", label: "Hours")
                    }
                    .padding(.vertical, 16)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)

                    // MARK: Account Section
                    SettingsSectionView(title: "Account") {
                        SettingsRowView(icon: "person.fill", iconColor: .blue, label: "Edit Profile") {
                            showingEditAlert = true
                        }
                        Divider().padding(.leading, 52)
                        SettingsRowView(icon: "envelope.fill", iconColor: .green, label: user.email, isInfo: true) {}
                        Divider().padding(.leading, 52)
                        SettingsRowView(icon: "briefcase.fill", iconColor: .orange, label: user.role, isInfo: true) {}
                    }
                    .padding(.horizontal)

                    // MARK: Preferences Section
                    SettingsSectionView(title: "Preferences") {
                        ToggleRowView(icon: "bell.fill", iconColor: .red, label: "Notifications", value: $notificationsEnabled)
                        Divider().padding(.leading, 52)
                        ToggleRowView(icon: "moon.fill", iconColor: .indigo, label: "Dark Mode", value: $darkModeEnabled)
                        Divider().padding(.leading, 52)
                        ToggleRowView(icon: "chart.bar.fill", iconColor: .purple, label: "Analytics", value: $analyticsEnabled)
                    }
                    .padding(.horizontal)

                    // MARK: Support Section
                    SettingsSectionView(title: "Support") {
                        SettingsRowView(icon: "questionmark.circle.fill", iconColor: .blue, label: "Help Center") {}
                        Divider().padding(.leading, 52)
                        SettingsRowView(icon: "star.fill", iconColor: .yellow, label: "Rate the App") {}
                        Divider().padding(.leading, 52)
                        SettingsRowView(icon: "info.circle.fill", iconColor: .gray, label: "Version 1.0.0", isInfo: true) {}
                    }
                    .padding(.horizontal)

                    // MARK: Logout
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.red)
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Edit Profile", isPresented: $showingEditAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Profile editing would be available in the full version.")
            }
        }
    }
}

// MARK: - Profile Stat View
struct ProfileStatView: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Settings Section
struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                content
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

// MARK: - Settings Row
struct SettingsRowView: View {
    let icon: String
    let iconColor: Color
    let label: String
    var isInfo: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor)
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Spacer()
                if isInfo {
                    EmptyView()
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Toggle Row
struct ToggleRowView: View {
    let icon: String
    let iconColor: Color
    let label: String
    @Binding var value: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Text(label)
                .font(.subheadline)
            Spacer()
            Toggle("", isOn: $value)
                .labelsHidden()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

#Preview {
    ProfileView()
}
